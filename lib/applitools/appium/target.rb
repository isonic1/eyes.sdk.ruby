# frozen_string_literal: true

module Applitools
  module Appium
    class Target
      include Applitools::FluentInterface

      attr_accessor :region_to_check, :options

      class << self
        def window
          new
        end

        def region(*args)
          new.region(*args)
        end
      end

      def initialize
        self.region_to_check = proc { Applitools::Region::EMPTY }
        self.options = {}
      end

      def region(*args)
        self.region_to_check = case args.first
                               when ::Selenium::WebDriver::Element
                                 proc { args.first }
                               else
                                 proc do |driver|
                                   driver.find_element(*args)
                                 end
                               end
        self
      end

      def finalize
        self
      end
    end
  end
end
