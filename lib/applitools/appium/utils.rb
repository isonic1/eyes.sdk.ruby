# frozen_string_literal: false

module Applitools::Appium
  module Utils
    # true if test is running on mobile device
    def mobile_device?(driver)
      defined?(Appium::Driver) && driver.respond_to?(:appium_driver) && driver.appium_driver
    end

    # true if test is running on Android device
    def android?(driver)
      driver.respond_to?(:device_is_android?) && driver.device_is_android?
    end

    # true if test is running on iOS device
    def ios?(driver)
      driver.respond_to?(:device_is_ios?) && driver.device_is_ios?
    end

    # @param [Applitools::Selenium::Driver] driver
    def platform_version(driver)
      driver.respond_to?(:caps) && driver.caps[:platformVersion]
    end

    # @param [Applitools::Selenium::Driver] executor
    def device_pixel_ratio(executor)
      if executor.respond_to? :session_capabilities
        session_info = executor.session_capabilities
        return session_info['pixelRatio'].to_f if session_info['pixelRatio']
      end
      Applitools::Selenium::Eyes::UNKNOWN_DEVICE_PIXEL_RATIO
    end

    def current_scroll_position(driver)
      super
    rescue
      Applitools::Location::TOP_LEFT
    end
  end
end
