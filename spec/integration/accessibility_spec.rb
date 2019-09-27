require 'spec_helper'

RSpec.describe 'Accessibility', selenium: true do
  let(:url_for_test) { 'https://applitools.github.io/demo/TestPages/FramesTestPage/' }
  before(:each) { eyes.accessibility_validation = Applitools::Selenium::AccessibilityLevel::AAA }
  let(:target) do
    Applitools::Selenium::Target.window.accessibility(
      :css, '.ignore',
      type: Applitools::Selenium::AccessibilityRegionType::GRAPHICAL_OBJECT
    )
  end

  it 'TestAccessibilityRegions' do
    eyes.check('step1', target)
    add_expected_property('accessibilityLevel', Applitools::Selenium::AccessibilityLevel::AAA)
  end
end