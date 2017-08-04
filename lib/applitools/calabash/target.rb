module Applitools
  module Calabash
    class Target < Applitools::Images::Target
      attr_reader :scale_factor

      class << self
        alias_method :android, :path

        def ios(path, scale_factor)
          path(path, scale_factor)
        end


        def path(path, scale_factor = 1)
          raise Applitools::EyesIllegalArgument unless File.exist?(path)
          new(Applitools::Screenshot.from_image(::ChunkyPNG::Image.from_file(path)), scale_factor)
        end
      end

      def initialize(image, scale_factor = 1)
        super(image)
        @scale_factor = scale_factor
      end

      def ignore(*args)
        return super unless (element = args.first).is_a? Applitools::Calabash::CalabashElement
        super(Applitools::Region.from_location_size(element.location, element.size).scale_it!(scale_factor))
      end

      def region(*args)
        return super unless (element = args.first).is_a? Applitools::Calabash::CalabashElement
        super(Applitools::Region.from_location_size(element.location, element.size).scale_it!(scale_factor))
      end

      def floating(*args)
        value = case args.first
                  when Applitools::FloatingRegion
                    proc { args.first.scale_it!(scale_factor) }
                  when Applitools::Region
                    proc do
                      region = args.shift
                      region.scale_it!(scale_factor)
                      Applitools::FloatingRegion.new region.left, region.top, region.width, region.height, *args
                    end
                  else
                    self.floating_regions = []
                end
        floating_regions << value
        self
      end
    end
  end
end