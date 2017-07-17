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
        FileUtils.rmdir(File.join Dir.getwd, eyes_settings.tmp_dir)
        FileUtils.rmdir(File.join Dir.getwd, eyes_settings.log_dir)
      end
    end
  end
end