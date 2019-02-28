# frozen_string_literal: false

module Applitools::Appium
  module Init19
    extend self

    def init
      Applitools::Utils::EyesSeleniumUtils.module_eval do
        alias_method :super_mobile_device?, :mobile_device?
        alias_method :super_android?, :android?
        alias_method :super_ios?, :ios?
        alias_method :super_platform_version, :platform_version
        alias_method :super_current_scroll_position, :current_scroll_position
        include Applitools::Appium::Utils
      end
    end
  end
end
