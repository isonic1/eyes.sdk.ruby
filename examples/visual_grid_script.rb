# frozen_string_literal: true

require 'eyes_selenium'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
Applitools::EyesLogger.log_handler = Logger.new(STDOUT).tap do |l|
  l.level = Logger::Severity::INFO
end
@runner = Applitools::Selenium::VisualGridRunner.new(10)
@eyes = Applitools::Selenium::Eyes.new(runner: @runner)
@web_driver = Selenium::WebDriver.for :chrome

@eyes.configure do |config|
  config.app_name = 'Eyes SDK Ruby'
  config.test_name = 'Visual Grid Ruby Example'
  config.viewport_size = Applitools::RectangleSize.new(1280, 600)
  config.add_browser(1600, 1200, BrowserTypes::CHROME)
        .add_browser(1600, 1200, BrowserTypes::CHROME_ONE_VERSION_BACK)
        .add_device_emulation(Devices::BlackBerryZ30, Orientations::PORTRAIT)
  config.proxy = Applitools::Connectivity::Proxy.new('http://localhost:8000')
end

@driver = @eyes.open(driver: @web_driver)

@driver.get('https://applitools.com/helloworld')
@eyes.check('Step1', Applitools::Selenium::Target.window.fully)
@eyes.close_async
@web_driver.quit

puts @runner.get_all_test_results(false)
