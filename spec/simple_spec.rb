require 'rspec'
require 'eyes_selenium'

RSpec.describe 'simple browser test' do
  let(:web_driver) { Selenium::WebDriver.for(:chrome) }
  let(:eyes) { Applitools::Selenium::Eyes.new.tap { |e| e.log_handler = Logger.new(STDOUT) } }
  let(:driver) { eyes.open(driver: web_driver, app_name: "Proba", test_name: "proba_test", viewport_size: {width: 800, height: 600}) }
  let(:target) { Applitools::Selenium::Target.window }
  it 'simple' do
    driver.get('https://applitools.com/helloworld?diff2')
    eyes.check('Tag', target)
    eyes.close_async
    driver.quit
  end
end