require 'applitools/selenium/concerns/browser_types'

module Applitools
  module Selenium
    class RenderBrowserInfo < ::Applitools::AbstractConfiguration
      DEFAULT_CONFIG = {
        platform: 'linux',
        browser_type: Applitools::Selenium::Concerns::BrowserTypes::CHROME,
        size_mode: 'full-page',
        viewport_size: Applitools::RectangleSize.from_any_argument(width: 0, height: 0)
      }.freeze

      class << self
        def default_config
          DEFAULT_CONFIG
        end
      end

      object_field :viewport_size, Applitools::RectangleSize
      enum_field :browser_type, Applitools::Selenium::Concerns::BrowserTypes.enum_values
      string_field :platform
      string_field :size_mode
      string_field :baseline_env_name
    end
  end
end