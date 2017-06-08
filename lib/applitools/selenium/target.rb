module Applitools
  module Selenium
    class Target
      include Applitools::FluentInterface
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
        self.options = {
          ignore_caret: false,
          ignore_mismatch: false
        }
        reset_for_fullscreen
      end

      # Add the wanted ignored regions.
      #
      # @param [Array] *args The arguments to ignore.
      # @option args [String] :name The name of the region to ignore.
      # @option args [Integer] :id The id of the region to ignore.
      def ignore(*args)
        if args.empty?
          reset_ignore
        else
          ignored_regions << case args.first
                             when Applitools::Selenium::Element, Applitools::Region, ::Selenium::WebDriver::Element
                               proc { args.first }
                             else
                               proc do |driver|
                                 driver.find_element(*args)
                               end
                             end

        end
        self
      end

      def floating(*args)
        value = case args.first
                when Applitools::FloatingRegion
                  proc { args.first }
                when ::Selenium::WebDriver::Element, Applitools::Selenium::Element
                  proc { Applitools::FloatingRegion.any args.shift, *args }
                when Applitools::Region
                  proc do
                    region = args.shift
                    Applitools::FloatingRegion.new region.left, region.top, region.width, region.height, *args
                  end
                else
                  proc do |driver|
                    Applitools::FloatingRegion.any driver.find_element(args.shift, args.shift), *args
                  end
                end
        floating_regions << value
        self
      end

      def fully
        options[:stitch_content] = true
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
                               when Applitools::Selenium::Element, Applitools::Region, ::Selenium::WebDriver::Element
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
