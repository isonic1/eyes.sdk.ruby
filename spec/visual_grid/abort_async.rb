# frozen_string_literal: true
require 'eyes_selenium'

# rubocop:disable Lint/UnreachableCode
runner = Applitools::Selenium::VisualGridRunner.new(10)
web_driver = Selenium::WebDriver.for :chrome
eyes = Applitools::Selenium::Eyes.new(runner: runner)

begin
  driver = eyes.open(
    app_name: 'Eyes SDK Ruby',
    test_name: 'abort_async',
    viewport_size: Applitools::RectangleSize.new(800, 600),
    driver: web_driver
  )
  driver.get('https://applitools.com')
  eyes.check_window('step1')
  eyes.check_window('step2')
  raise Applitools::EyesError.new('Error in users thread')
  eyes.check_window('step3')
  eyes.close_async
rescue Applitools::EyesError
  eyes.abort_async
ensure
  web_driver.quit
  results = runner.get_all_test_results(false)
  puts results
end
# rubocop:enable Lint/UnreachableCode
