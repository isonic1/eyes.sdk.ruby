module Applitools::Images
  class Target
    class << self
      def path(path)
        raise Applitools::EyesIllegalArgument unless File.exist?(path)
        new Applitools::Screenshot.from_image(ChunkyPNG::Image.from_file(path))
      end

      def blob(blob_image)
        Applitools::ArgumentGuard.not_nil blob_image, 'blob_image'
        Applitools::ArgumentGuard.is_a? blob_image, 'blob_image', String
        new Applitools::Screenshot.from_datastream(blob_image)
      end

      def image(image)
        Applitools::ArgumentGuard.not_nil image, 'image'
        Applitools::ArgumentGuard.is_a? image, 'image', ChunkyPNG::Image
        new Applitools::Screenshot.from_image(image)
      end

      def screenshot(screenshot)
        Applitools::ArgumentGuard.not_nil screenshot, 'screenshot'
        Applitools::ArgumentGuard.is_a? screenshot, 'screenshot', Applitools::Screenshot
        new screenshot
      end

      def any

      end
    end

    attr_accessor :image, :options, :ignore_regions, :region_to_check

    def initialize(image)
      Applitools::ArgumentGuard.not_nil(image, 'image')
      Applitools::ArgumentGuard.is_a? image, 'image', Applitools::Screenshot
      self.image = image
    end

    def ignore
      self
    end

    def region(region)
      self.region_to_check = region
      self
    end

    def trim
      self
    end

    def region_provider

    end
  end
end