# frozen_string_literal: true

module Applitools
  module Appium
    class RegionProvider
      attr_accessor :driver, :eye_region, :coordinate_type

      def initialize(driver, eye_region)
        self.driver = driver
        self.eye_region = eye_region
      end

      def region
        return Applitools::Region::EMPTY if
            [::Selenium::WebDriver::Element, Applitools::Selenium::Element].include? eye_region.class
        region = driver.session_capabilities['viewportRect']
        Applitools::Region.new(
          region['left'],
          region['top'],
          region['width'],
          region['height']
        )
      end
    end
  end
end
