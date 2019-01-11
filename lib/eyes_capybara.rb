# frozen_string_literal: true

require 'eyes_selenium'
require 'capybara'

Applitools::Selenium.require_dir 'capybara'

module Applitools
  extend Applitools::Selenium::Capybara::CapybaraSettings
  register_capybara_driver
end
