module Applitools
  module Appium
    class Screenshot < Applitools::EyesScreenshot
      def sub_screenshot(region, _coordinate_type, throw_if_clipped = false, force_nil_if_clipped = false)
        self.class.new(
            Applitools::Screenshot.from_image(
                image.crop(region.x, region.y, region.width, region.height)
            )
        )
      end
    end
  end
end