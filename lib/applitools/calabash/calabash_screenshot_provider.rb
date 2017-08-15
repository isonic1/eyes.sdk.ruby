module Applitools
  module Calabash
    class AndroidScreenshotProvider
      include Singleton
      def capture_screenshot(context, density)
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

    class IosScreenshotProvider
      include Singleton
      def capture_screenshot(context, density)
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