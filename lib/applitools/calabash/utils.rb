module Applitools
  module Calabash
    module Utils
      extend self

      def create_directories(eyes_settings)
        FileUtils.mkpath(
          File.join(Dir.getwd, eyes_settings.tmp_dir, eyes_settings.screenshot_dir)
        )
        FileUtils.mkpath(
          File.join(Dir.getwd, eyes_settings.log_dir)
        )
      end

      def clear_directories(eyes_settings)
        FileUtils.remove_dir(File.join Dir.getwd, eyes_settings.tmp_dir)
        FileUtils.remove_dir(File.join Dir.getwd, eyes_settings.log_dir)
      end

      def using_screenshot(context)
        return unless block_given?
        screenshot_options = Applitools::Calabash::EyesSettings.instance.screenshot_names.next
        yield context.screenshot(screenshot_options)
      end

      def region_from_element(element)
        Applitools::Region.new(
          element['rect']['x'],
          element['rect']['y'],
          element['rect']['width'],
          element['rect']['height'],
        )
      end

      def pixel_ratio(context)

      end
    end
  end
end