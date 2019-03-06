# frozen_string_literal: true

require_relative '../lib/eyes_selenium'
require 'logger'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

eyes = Applitools::Selenium::Eyes.new
eyes.api_key = ENV['APPLITOOLS_API_KEY']
eyes.log_handler = Logger.new(STDOUT)
eyes.match_level = Applitools::MATCH_LEVEL[:layout]

begin
  web_driver = Selenium::WebDriver.for :chrome
  eyes.test(
    app_name: 'Ruby SDK',
    test_name: 'Applitools website test',
    viewport_size: { width: 800, height: 600 },
    driver: web_driver
  ) do |driver|
    driver.get 'http://www.applitools.com'
    eyes.check_window('initial')
    eyes.check_region(:css, 'a.logo', tag: 'Applitools logo')
  end

  driver = eyes.open(driver: web_driver) do |config|
    config.app_name = 'Ruby SDK'
    config.test_name = 'Applitools website test 1'
    config.viewport_size = Applitools::RectangleSize.from_any_argument(width: 850, height: 600)
  end

  driver.get 'http://www.applitools.com'
  eyes.check_window('initial')
  eyes.check_region(:css, 'a.logo', tag: 'Applitools logo')
  eyes.close

  cnf = Applitools::Selenium::SeleniumConfiguration.new.tap do |config|
    config.app_name = 'Ruby SDK'
    config.test_name = 'Applitools website test 2'
    config.viewport_size = Applitools::RectangleSize.from_any_argument(width: 900, height: 600)
  end

  driver = eyes.open(driver: web_driver, config: cnf)
  driver.get 'http://www.applitools.com'
  eyes.check_window('initial')
  eyes.check_region(:css, 'a.logo', tag: 'Applitools logo')
  eyes.close

ensure
  web_driver.quit
end
