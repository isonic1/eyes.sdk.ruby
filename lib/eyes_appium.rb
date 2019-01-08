# frozen_string_literal: false

require 'eyes_selenium'
require 'appium_lib'

CURRENT_RUBY_VERSION = Gem::Version.new RUBY_VERSION

RUBY_1_9_3 = Gem::Version.new '1.9.3'
RUBY_2_0_0 = Gem::Version.new '2.0.0'
RUBY_2_1_6 = Gem::Version.new '2.1.6'
RUBY_2_2_2 = Gem::Version.new '2.2.2'
RUBY_2_4_0 = Gem::Version.new '2.4.0'

RUBY_KEY = [RUBY_1_9_3, RUBY_2_0_0, RUBY_2_1_6, RUBY_2_2_2, RUBY_2_4_0].select { |v| v <= CURRENT_RUBY_VERSION }.last

Applitools.require_dir('appium')

if RUBY_KEY >= RUBY_2_0_0
  Applitools::Appium::Init20.init
else
  Applitools::Appium::Init19.init
end

if defined? Appium::Driver
  Appium::Driver.class_eval do
    def driver_for_eyes(eyes)
      Applitools::Selenium::Driver.new(eyes, driver: driver || start_driver, is_mobile_device: true)
    end
  end
end
