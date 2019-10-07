RSpec.shared_context "selenium workaround" do
  before(:all) do
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

    Applitools::EyesLogger.log_handler = Logger.new(STDOUT)
    if self.class.metadata[:visual_grid]
      @runner = Applitools::Selenium::VisualGridRunner.new(10)
      @eyes = Applitools::Selenium::Eyes.new(visual_grid_runner: @runner)
    else
      @eyes = Applitools::Selenium::Eyes.new
    end
  end

  before do |example|
    eyes.hide_scrollbars = true
    # eyes.save_new_tests = false
    #
    eyes.set_proxy('http://localhost:8000')
    eyes.force_full_page_screenshot = false
    eyes.stitch_mode = Applitools::Selenium::StitchModes::CSS
    eyes.force_full_page_screenshot = true if example.metadata[:fps]
    eyes.stitch_mode = Applitools::Selenium::StitchModes::SCROLL if example.metadata[:scroll]
    eyes.server_url = 'https://eyesfabric4eyes.applitools.com'
    driver.get(url_for_test)
  end

  after(:each) do

  end

  around(:example) do |example|
    begin
      @expected_properties = {}
      @expected_accessibility_regions = []
      @eyes_test_result = nil
      example.run
      @eyes_test_result = eyes.close if eyes.open?
      check_expected_properties
      check_expected_accessibility_regions
    ensure
      driver.quit
      eyes.abort_if_not_closed
    end
  end

  let(:eyes_test_result) { @eyes_test_result }

  let(:actual_app_output) { session_results['actualAppOutput'] }

  let(:app_output_image_match_settings) { actual_app_output[0]['imageMatchSettings'] }
  let(:app_output_accessibility) { app_output_image_match_settings['accessibility'] }

  let(:session_results) do
    Oj.load(Net::HTTP.get(session_results_url))
  end

  let(:session_query_params) do
    URI.encode_www_form('AccessToken' => eyes_test_result.secret_token, 'apiKey' => eyes.api_key, 'format' => 'json')
  end

  let(:session_results_url) do
    url = URI.parse(eyes_test_result.api_session_url)
    url.query = session_query_params
    url
  end

  let(:driver) do
    eyes.open(
        app_name: app_name, test_name: test_name, viewport_size: viewport_size, driver: web_driver
    )
  end
  let(:web_driver) do
    case ENV['BROWSER']
    when 'chrome'
      Selenium::WebDriver.for :chrome, options: chrome_options
    when 'firefox'
    else
      Selenium::WebDriver.for :chrome
    end
  end
  let(:eyes) { @eyes }
  let(:app_name) do |example|
    root_example_group = proc do |group|
      next group[:description] unless group[:parent_example_group] && group[:parent_example_group][:selenium]
      root_example_group.call(group[:parent_example_group])
    end
    root_example_group.call(example.metadata[:example_group])
  end
  let(:test_name) do |example|
    name_modifiers = [example.description]
    name_modifiers << [:FPS] if eyes.force_full_page_screenshot
    name_modifiers << [:Scroll] unless eyes.stitch_mode == Applitools::STITCH_MODE[:css]
    # name_modifiers << [:VG] if eyes.is_a? Applitools::Selenium::VisualGridEyes
    name_modifiers.join('_')
  end
  let(:viewport_size) { {width: 700, height: 460} }
  let(:chrome_options) do
    Selenium::WebDriver::Chrome::Options.new(
        options: { args: %w(headless disable-gpu no-sandbox disable-dev-shm-usage) }
    )
  end

  let(:test_results) { @eyes_test_result }


  # after(:all) do
  #
  # end
  def expected_accessibility_regions(*args)
    return @expected_accessibility_regions += args.first if args.length == 1 && args.first.is_a?(Array)
    @expected_accessibility_regions += args
  end

  def expected_property(key, value)
    @expected_properties[key] = value
  end

  def check_expected_properties
    @expected_properties.each do |k,v|
      path = k.split /\./
      current_hash = app_output_image_match_settings
      path.each do |prop|
        current_hash = current_hash[prop.to_s]
      end
      expect(current_hash).to eq(v)
    end
  end

  def check_expected_accessibility_regions
    received_accessibility_regions = app_output_accessibility.map do |r|
      Applitools::AccessibilityRegion.new(
        Applitools::Region.new(r['left'], r['top'], r['width'], r['height']),
        r['type']
      )
    end
    @expected_accessibility_regions.each do |ar|
      expect(received_accessibility_regions).to include(ar)
    end
  end
end
