# frozen_string_literal: true

require 'eyes_selenium'

runner = Applitools::Selenium::VisualGridRunner.new(5)
eyes = Applitools::Selenium::Eyes.new(runner: runner)
eyes.log_handler = Logger.new(STDOUT)

web_driver = Selenium::WebDriver.for :chrome

driver = eyes.open(
  app_name: 'svg_vg',
  test_name: 'sample',
  viewport_size: Applitools::RectangleSize.new(1024, 786),
  driver: web_driver
)
driver.get('https://danielschwartz85.github.io/static-test-page2/index.html')

eyes.check_window('step0')
eyes.close_async

driver.quit
puts runner.get_all_test_results(false)
