# frozen_string_literal: true

require 'eyes_selenium'
require 'eyes_images'
require 'eyes_calabash'
require 'eyes_capybara'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.shared_context "selenium workaround" do
  before(:all) do
    @eyes = Applitools::Selenium::Eyes.new
  end

  before do |example|
    eyes.hide_scrollbars = true
    eyes.save_new_tests = false
    eyes.force_full_page_screenshot = false
    eyes.stitch_mode = Applitools::Selenium::StitchModes::CSS
    eyes.force_full_page_screenshot = true if example.metadata[:fps]
    eyes.stitch_mode = Applitools::Selenium::StitchModes::SCROLL if example.metadata[:scroll]
    driver.get(url_for_test)
  end

  after(:each) do

  end

  around(:example) do |example|
    begin
      example.run
      eyes.close if eyes.open?
    ensure
      driver.quit
      eyes.abort_if_not_closed
    end
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

  # after(:all) do
  #
  # end
end

RSpec.configure do |config|
  config.before mock_connection: true do
    allow_any_instance_of(Applitools::Connectivity::ServerConnector).to receive(:start_session) do
      Applitools::Session.new('dummy_id', 'dummy_url', true)
    end

    allow_any_instance_of(Applitools::Connectivity::ServerConnector).to receive(:stop_session) do
      Applitools::TestResults.new
    end

    allow_any_instance_of(Applitools::Connectivity::ServerConnector).to receive(:match_window) do
      true
    end
  end

  config.before clear_environment: true do
    Applitools::Helpers.instance_variable_set :@environment_variables, {}
  end

  config.include_context "selenium workaround", :selenium => true
end
