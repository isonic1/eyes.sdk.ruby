# frozen_string_literal: false

module Applitools::Appium
  module Utils
    # true if test is running on mobile device
    def mobile_device?
      return nil unless defined?(Appium::Driver)
      return $driver if $driver && $driver.is_a?(Appium::Driver)
    end

    # true if test is running on Android device
    def android?(driver)
      driver.respond_to?(:appium_device) && driver.appium_device == :android
    end

    # true if test is running on iOS device
    def ios?(driver)
      driver.respond_to?(:appium_device) && driver.appium_device == :ios
    end

    # @param [Applitools::Selenium::Driver] driver
    def platform_version(driver)
      driver.respond_to?(:caps) && driver.caps[:platformVersion]
    end

    # def current_position
    #   result = nil
    #   begin
    #     logger.info 'current_position()'
    #     result = Applitools::Utils::EyesSeleniumUtils.current_scroll_position(executor)
    #     logger.info "Current position: #{result}"
    #   rescue Applitools::EyesDriverOperationException
    #     result = Applitools::Location::TOP_LEFT
    #   end
    #   result
    # end

    def current_scroll_position(driver)
      super
    rescue
      Applitools::Location::TOP_LEFT
    end
  end
end
