module Applitools
  module Selenium
    class EmulationBaseInfo
      module ORIENTATIONS
        PORTRAIT = 'portrait'
        LANDSCAPE = 'landscape'
      end
      extend Applitools::Helpers
      attr_accessor :screen_orientation
      abstract_attr_accessor :device_name

      def initialize(screen_orientation)
        self.screen_orientation = screen_orientation
      end
    end
  end
end