module Applitools
  module Calabash
    class CalabashScreenshotProvider
      attr_reader :density, :context

      def initialize
        @density = 1
      end

      def with_density(value)
        @density = value
        self
      end

      def using_context(value)
        @context = value
        self
      end
    end

    class AndroidScreenshotProvider < CalabashScreenshotProvider
      include Singleton

      def capture_screenshot
        result = nil
        Applitools::Calabash::Utils.using_screenshot(context) do |screenshot_path|
          result = Applitools::Calabash::EyesCalabashAndroidScreenshot.new(
            Applitools::Screenshot.from_image(
             ::ChunkyPNG::Image.from_file(screenshot_path)
            ),
            density: density
          )
        end
        result
      end
    end

    class IosScreenshotProvider < CalabashScreenshotProvider
      include Singleton
      def capture_screenshot
        result = nil
        Applitools::Calabash::Utils.using_screenshot(context) do |screenshot_path|
          result = Applitools::Calabash::EyesCalabashIosScreenshot.new(
            Applitools::Screenshot.from_image(
              ::ChunkyPNG::Image.from_file(screenshot_path)
            ),
            scale_ratio: density
          )
        end
        result
      end
    end
  end
end