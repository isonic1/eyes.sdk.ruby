require 'spec_helper'
require_relative 'integration/test_api'

RSpec.describe do

  let(:test_suit_name) { 'Eyes Selenium SDK - Fluent API' }
  let(:tested_page_url) { 'http://applitools.github.io/demo/TestPages/FramesTestPage/' }
  let(:force_fullpage_screenshot) { false }
  let(:caps) {
    Selenium::WebDriver::Remote::Capabilities.chrome(
        "chromeOptions" => {
            "args" => [ "disable-infobars", "Zheadless" ]
        }
    )
  }

  include_context 'eyes integration test' do
    let(:platform) { 'linux' }
  end

  before do
    eyes.debug_screenshot = true
  end


  it 'TestCheckFrameInFrame_Fully_Fluent' do
    target = Applitools::Selenium::Target.frame('frame1').frame('frame1-1').fully
    eyes.check('Fluent - Full Frame in Frame', target)
  end
end

