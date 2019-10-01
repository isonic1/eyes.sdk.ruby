require 'spec_helper'

RSpec.describe 'Selenium' do
  before(:each) { eyes.accessibility_validation = Applitools::Selenium::AccessibilityLevel::AAA }

  describe 'Accessibility', selenium: true do
    let(:url_for_test) { 'https://applitools.github.io/demo/TestPages/FramesTestPage/' }
    let(:target) do
      Applitools::Selenium::Target.window.accessibility(
          :css, '.ignore',
          type: Applitools::Selenium::AccessibilityRegionType::GRAPHICAL_OBJECT
      )
    end

    it 'TestAccessibilityRegions' do
      eyes.check('step1', target)
      expected_property('accessibilityLevel', Applitools::Selenium::AccessibilityLevel::AAA)
      expected_accessibility_regions(
        Applitools::Selenium::AccessibilityRegion.new(
          Applitools::Region.new(10, 284, 800, 500),
          Applitools::Selenium::AccessibilityRegionType::GRAPHICAL_OBJECT),
        Applitools::Selenium::AccessibilityRegion.new(
          Applitools::Region.new(8, 1270, 690, 206),
          Applitools::Selenium::AccessibilityRegionType::GRAPHICAL_OBJECT),
        Applitools::Selenium::AccessibilityRegion.new(
          Applitools::Region.new(127, 928, 456, 306),
          Applitools::Selenium::AccessibilityRegionType::GRAPHICAL_OBJECT)
      )
    end
  end
end