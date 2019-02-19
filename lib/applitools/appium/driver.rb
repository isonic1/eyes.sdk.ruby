module Applitools::Appium
  class Driver < Applitools::Selenium::Driver
    attr_accessor :appium_driver
    def initialize(eyes, options)
      self.appium_driver = options.delete(:appium_driver)
      super(eyes, options)
    end
  end
end