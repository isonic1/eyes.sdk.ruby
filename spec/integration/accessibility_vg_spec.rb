require 'spec_helper'

RSpec.describe 'VG' do
  # This :before hook will be executed BEFORE hooks, defined in :selenium or :visual_grid contexts
  before(:each) { eyes.accessibility_validation = Applitools::Selenium::AccessibilityLevel::AAA }

  describe 'Accessibility', visual_grid: true do
    let(:url_for_test) { 'https://applitools.github.io/demo/TestPages/FramesTestPage/' }
    let(:target) do
      Applitools::Selenium::Target.window.accessibility(
          :css, '.ignore',
          type: Applitools::Selenium::AccessibilityRegionType::GRAPHICAL_OBJECT
      ).ignore(:css, 'iframe')
    end

    it 'TestAccessibilityRegions' do
      eyes.check('step1', target)
      expected_property('accessibilityLevel', Applitools::Selenium::AccessibilityLevel::AAA)
    end
  end
end
