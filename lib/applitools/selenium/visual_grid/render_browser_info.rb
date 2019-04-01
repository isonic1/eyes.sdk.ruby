require 'applitools/selenium/browser_types'

module Applitools
  module Selenium
    class RenderBrowserInfo < ::Applitools::AbstractConfiguration
      DEFAULT_CONFIG = proc do
        {
          platform: 'linux',
          browser_type: Applitools::Selenium::BrowserTypes::CHROME,
          size_mode: 'full-page',
          viewport_size: Applitools::RectangleSize.from_any_argument(width: 0, height: 0)
        }
      end
      class << self
        def default_config
          DEFAULT_CONFIG.call
        end
      end

      object_field :viewport_size, Applitools::RectangleSize
      enum_field :browser_type, Applitools::Selenium::BrowserTypes.enum_values
      string_field :platform
      string_field :size_mode
      string_field :baseline_env_name

      def to_s
        "#{viewport_size} (#{browser_type})"
      end
    end
  end
end