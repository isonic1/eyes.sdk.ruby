# frozen_string_literal: true

require 'eyes_selenium'
require 'eyes_images'
require 'eyes_calabash'
require 'eyes_capybara'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.shared_context "selenium workaround", :shared_context => :metadata do
  before(:all) do |exaqmple|
    @eyes = Applitools::Selenium::Eyes.new
    @eyes.batch = Applitools::BatchInfo.new(self.class.description)
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
  let(:app_name) { self.class.description } #self.class.description.metadata
  let(:test_name) { |example| example.description }
  let(:viewport_size) { {width: 800, height: 600} }
  let(:chrome_options) { Selenium::WebDriver::Chrome::Options.new(options: { args: %w(--headless --disable-gpu --window-size=1400,1400 --disable-infobars --no-sandbox --disable-dev-shm-usage) }) }

  after(:all) do

  end
  before { @some_var = :some_value }
  def shared_method
    "it works"
  end
  let(:shared_let) { {'arbitrary' => 'object'} }
  subject do
    'this is the subject'
  end
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
