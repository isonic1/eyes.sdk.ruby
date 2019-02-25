# frozen_string_literal: false

module Applitools::Appium
  module Init20
    extend self
    def init
      Applitools::Utils::EyesSeleniumUtils.module_eval do
        prepend Applitools::Appium::Utils
        extend self
      end
    end
  end
end
