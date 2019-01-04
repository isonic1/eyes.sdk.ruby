module Applitools::Appium
  module Init1_9
    extend self

    def init
      Applitools::Utils::EyesSeleniumUtils.module_eval do
        alias_method :super_mobile_device?, :mobile_device?
        alias_method :super_android?, :android?
        alias_method :super_ios?, :ios?
        alias_method :super_platform_version, :platform_version
        include Applitools::Appium::Utils
      end

      Applitools::Selenium::Eyes.class_eval do
        include Applitools::Appium::Eyes
      end
    end
  end
end