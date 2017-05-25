module Applitools
  module Selenium
    class Target
      class << self
        def frame(element)
          new.frame(element)
        end

        def window
          new
        end

        def region(element)
          new.region(element)
        end
      end

      attr_accessor :element, :frames, :region_to_check, :coordinate_type, :options, :ignored_regions, :floating_regions

      # Initialize a Applitools::Selenium::Target instance.
      def initialize
        self.frames = []
        self.options = { ignore_caret: false }
        reset_for_fullscreen
      end

      # Add the wanted ignored regions.
      #
      # @param [Array] *args The arguments to ignore.
      # @option args [String] :name The name of the region to ignore.
      # @option args [Integer] :id The id of the region to ignore.
      def ignore(*args)
        unless args.empty?
          ignored_regions << case args.first
                             when Applitools::Selenium::Element
                               proc { args.first }
                             when Applitools::Region
                               proc { args.first }
                             else
                               proc do |driver|
                                 driver.find_element(*args)
                               end
                             end
        else
          reset_ignore
        end
        self
      end

      def ignore_caret(value = false)
        options[:ignore_caret] = value ? true : false
        self
      end

      def floating(*args)
        value = case args.first
                when Applitools::FloatingRegion
                  proc { args.first }
                when Applitools::Selenium::Element
                  proc { Applitools::FloatingRegion.for_element args.shift, *args }
                when Applitools::Region
                  proc do
                    region = args.shift
                    Applitools::FloatingRegion.new region.left, region.top, region.width, region.height, *args
                  end
                else
                  proc do |driver|
                    Applitools::FloatingRegion.for_element driver.find_element(args.shift, args.shift), *args
                  end
                end
        self.floating_regions << value
        self
      end

      def fully
        options[:stitch_content] = true
        self
      end

      def timeout(value)
        options[:timeout] = value
        self
      end

      def frame(element)
        frames << element
        reset_for_fullscreen
        self
      end

      # Add the desired region.
      #
      # @param [Array] *args The arguments to add.
      # @option args [Integer] :timeout The timeout.
      # @option args [Integer] :id The id of the region.
      # @return [Applitools::Selenium::Target] Self instance.
      def region(*args)
        self.region_to_check = case args.first
                               when Applitools::Selenium::Element
                                 proc { args.first }
                               when Applitools::Region
                                 proc { args.first }
                               else
                                 proc do |driver|
                                   driver.find_element(*args)
                                 end
                               end
        self.coordinate_type = Applitools::EyesScreenshot::COORDINATE_TYPES[:context_relative]
        options[:timeout] = nil
        reset_ignore
        reset_floating
        self
      end

      def trim
        options[:trim] = true
        self
      end

      private

      def reset_for_fullscreen
        self.coordinate_type = nil
        self.region_to_check = proc { Applitools::Region::EMPTY }
        reset_ignore
        reset_floating
        options[:stitch_content] = false
        options[:timeout] = nil
        options[:trim] = false
      end

      def reset_ignore
        self.ignored_regions = []
      end

      def reset_floating
        self.floating_regions = []
      end
    end
  end
end
