require 'applitools/selenium/concerns/stitch_modes'
require 'applitools/selenium/concerns/stitch_modes'
require 'applitools/selenium/concerns/browsers_info'

module Applitools
  module Selenium
    class SeleniumConfiguration < Applitools::EyesBaseConfiguration
      DEFAULT_CONFIG = {
        force_full_page_screenshot: false,
        wait_before_screenshots: 100,
        stitch_mode: Applitools::Selenium::Concerns::StitchModes::CSS,
        hide_scrollbars: false,
        hide_caret: false,
        browsers_info: Applitools::Selenium::Concerns::BrowsersInfo.new
      }

      class << self
        def default_config
          super.merge DEFAULT_CONFIG
        end
      end

      boolean_field :force_full_page_screenshot
      int_field :wait_before_screenshots
      enum_field :stitch_mode, Applitools::Selenium::Concerns::StitchModes.enum_values
      boolean_field :hide_scrollbars
      boolean_field :hide_caret

      object_field :browsers_info, Applitools::Selenium::Concerns::BrowsersInfo

      int_field :concurrent_sessions

      # private int waitBeforeScreenshots = DEFAULT_WAIT_BEFORE_SCREENSHOTS;
      # private StitchMode stitchMode = StitchMode.SCROLL;
      # private boolean hideScrollbars = true;
      # private boolean hideCaret = true;
      #
      # //Rendering Configuration
      # private int concurrentSessions = 3;
      # private boolean isThrowExceptionOn = false;
      # private Boolean isRenderingConfig = false;
      #
      # public enum BrowserType {CHROME, FIREFOX}
      # private List<RenderBrowserInfo> browsersInfo =
      def add_browser(b = nil)
        browser = b || Applitools::Selenium::RenderBrowserInfo.new
        yield(Applitools::Selenium::Concerns::RenderBrowserInfoFluent.new(browser)) if block_given?
        browsers_info.add browser
        self
      end
    end
  end
end