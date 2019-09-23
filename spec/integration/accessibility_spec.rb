require 'spec_helper'

RSpec.describe 'Accessibility', selenium: true do
  let(:url_to_test) { 'https://applitools.github.io/demo/TestPages/FramesTestPage/' }
  before(:each) { eyes.accessibility_validation = Applitools::Selenium::AccessibilityLevel::AAA }
  let(:target) do
    Applitools::Selenium::Target.window.accessibility(
      :css, '.ignore',
      region_type: Applitools::Selenium::AccessibilityRegionType::DISABLED_OR_INACTIVE
    )
  end

  # after(:each) do
  #   require 'pry'
  #   binding.pry
  # end

  it 'TestAccessibilityRegions' do
    driver.get(url_to_test)
    eyes.check('step1', target)
  end
end