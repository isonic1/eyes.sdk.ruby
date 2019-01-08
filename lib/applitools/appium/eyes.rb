# frozen_string_literal: false

module Applitools::Appium
  module Eyes
    def perform_driver_settings_for_appium_driver
      self.region_visibility_strategy = Applitools::Selenium::NopRegionVisibilityStrategy.new
      self.force_driver_resolution_as_viewport_size = true
    end

    private :perform_driver_settings_for_appium_driver
  end
end
