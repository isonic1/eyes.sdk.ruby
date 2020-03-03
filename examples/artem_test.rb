# frozen_string_literal: true

require 'eyes_selenium'
require 'selenium-webdriver'
require 'rubygems'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
Applitools::EyesLogger.log_handler = Logger.new(STDOUT)

# Initialize the eyes SDK and set your private API key.
eyes = Applitools::Selenium::Eyes.new(server_url: 'https://test3eyes.applitools.com')
eyes.api_key = 'iX0TszU2MGesRtzyiuUyVB9P9M0wTw54Y88oV104IrnUY110'
eyes.set_proxy('http://localhost:8000')
# Open a Chrome Browser.
driver = Selenium::WebDriver.for :chrome
begin
  # Start the test and set the browser's viewport size to 800x600.
  eyes.test(app_name: 'Hello World!', test_name: 'My first Selenium Ruby test!',
            viewport_size: { width: 800, height: 600 }, driver: driver) do
    # Navigate the browser to the "hello world!" web-site.
    driver.get 'https://applitools.com/helloworld'
    # Visual checkpoint #1.
    eyes.check_window('Hello!')
    # Click the "Click me!".
    driver.find_element(tag_name: 'button').click
    # Visual checkpoint #2.
    eyes.check_window('Click!')
  end
ensure
  # Close the browser.
  driver.quit
  # If the test was aborted before eyes.close was called, ends the test as aborted.
  eyes.abort_if_not_closed
end
