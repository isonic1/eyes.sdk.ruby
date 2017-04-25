module Applitools
  module Selenium
    class Target
      class << self
        def window
          self.new()
        end

        def region(element)
          self.new().region(element)
        end
      end

      attr_accessor  :element, :frames, :region_to_check, :coordinate_type, :options, :ignore

      def initialize()
        self.frames = []
        self.options = {}
        reset_for_fullscreen
      end

      def ignore(*args)
        if args.first.is_a? Applitools::Selenium::Element
          self.ignore << proc do
            args.first
          end
        else
          self.ignore << proc do |driver|
            driver.find_element *args
          end
        end
        self
      end

      def float(*args)
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

      def region(*args)
        if args.first.is_a? Applitools::Selenium::Element
          self.region_to_check = proc do
            args.first
          end
        else
          self.region_to_check = proc do |driver|
            driver.find_element *args
          end
        end
        self.coordinate_type = Applitools::EyesScreenshot::COORDINATE_TYPES[:context_relative]
        options[:timeout] = nil
        self
      end

      private

      def reset_for_fullscreen
        self.coordinate_type = nil
        self.region_to_check = proc { Applitools::Region::EMPTY }
        self.ignore = []
        options[:stitch_content] = false
        options[:timeout] = nil
      end
    end
  end
end

