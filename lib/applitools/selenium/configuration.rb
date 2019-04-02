require 'applitools/selenium/stitch_modes'
require 'applitools/selenium/stitch_modes'
require 'applitools/selenium/browsers_info'

module Applitools
  module Selenium
    class Configuration < Applitools::EyesBaseConfiguration
      DEFAULT_CONFIG = proc do
        {
          force_full_page_screenshot: false,
          wait_before_screenshots: 100,
          stitch_mode: Applitools::Selenium::StitchModes::CSS,
          hide_scrollbars: false,
          hide_caret: false,
          browsers_info: Applitools::Selenium::BrowsersInfo.new
        }
      end
      class << self
        def default_config
          super.merge DEFAULT_CONFIG.call
        end
      end

      boolean_field :force_full_page_screenshot
      int_field :wait_before_screenshots
      enum_field :stitch_mode, Applitools::Selenium::StitchModes.enum_values
      boolean_field :hide_scrollbars
      boolean_field :hide_caret
      boolean_field :send_dom

      object_field :browsers_info, Applitools::Selenium::BrowsersInfo

      int_field :concurrent_sessions

      def add_browser(*args)
        case args.size
        when 0, 1
          b = args[0]
          browser = b || Applitools::Selenium::RenderBrowserInfo.new
        when 3
          browser = Applitools::Selenium::RenderBrowserInfo.new.tap do |bi|
            bi.viewport_size = Applitools::RectangleSize.new(args[0], args[1])
            bi.browser_type = args[2]
          end
        end
        yield(Applitools::Selenium::RenderBrowserInfoFluent.new(browser)) if block_given?
        browsers_info.add browser
        self.viewport_size = browser.viewport_size unless viewport_size
        self
      end

      def add_device_emulation(emu)
        Applitools::ArgumentGuard.not_nil emu, 'emulation_info'
        Applitools::ArgumentGuard.is_a? emu, 'emulation_info', Applitools::Selenium::EmulationBaseInfo
        add_browser { |b| b.emulation_info(emu) }
      end

      def deep_clone
        new_config = self.class.new
        config_keys.each do |k|
          new_config.send("#{k}=", self.send(k).clone)
        end
        new_config
      end
    end
  end
end