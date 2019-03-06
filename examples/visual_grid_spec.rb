require 'rspec'
require 'eyes_selenium'
require 'pry'

RSpec.shared_examples 'Test for url' do |url|
  let(:url) { url }
  # let(:runner) { Applitools::Selenium::VisualGridRunner }
  let(:web_driver) { Selenium::WebDriver.for :chrome }

  let(:driver) do
    @eyes.open(driver: web_driver) do |config|
      config.app_name = 'Top 10 sites'
      config.test_name = "Top 10 sites - #{url}"
      config.add_browser { |b| b.width(800).height(600).type(Applitools::Selenium::Concerns::BrowserTypes::CHROME) }
            .add_browser { |b| b.width(700).height(500).type(Applitools::Selenium::Concerns::BrowserTypes::CHROME) }
            .add_browser { |b| b.width(1600).height(1200).type(Applitools::Selenium::Concerns::BrowserTypes::CHROME) }
    end
  end

  let(:terget1) { Applitools::Selenium::Target.window.send_dom(true) }
  let(:terget2) { Applitools::Selenium::Target.window.fully(false).send_dom(true) }

  let(:eyes) { @eyes }

  before(:all) do
    @eyes = Applitools::Selenium::Eyes.new(visual_grid_runner: Applitools::Selenium::VisualGridRunner.new )
  end

  after do
    @eyes.close
  end

  after(:all) do

  end

  it url do
    binding.pry
    driver.get(url)
    eyes.check('Step1' + url, target1)
    eyes.check('Step2' + url, target2)
  end
end

RSpec.describe 'My first visual grid test' do

  %w(
    https://google.com
    https://facebook.com
    https://youtube.com
    https://amazon.com
    https://ebay.com
    https://twitter.com
    https://wikipedia.org
    https://instagram.com
    https://www.target.com/c/blankets-throws/-/N-d6wsb?lnk=ThrowsBlankets%E2%80%9C,tc
  ).each do |url|
    it_behaves_like 'Test for url', url
  end
end