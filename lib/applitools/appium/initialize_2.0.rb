module Applitools::Appium
  module Init2_0
    extend self
    def init
      Applitools::Utils::EyesSeleniumUtils.module_eval do
        prepend Applitools::Appium::Utils
      end

      Applitools::Selenium::Eyes.class_eval do
        prepend Applitools::Appium::Eyes
      end

    end
  end
end
