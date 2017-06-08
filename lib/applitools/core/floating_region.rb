require_relative 'region'
module Applitools
  class FloatingRegion < Region
    class << self
      def any(element, max_left_offset, max_top_offset, max_right_offset, max_bottom_offset)
        case element
        when Applitools::Selenium::Element, ::Selenium::WebDriver::Element, Applitools::Region
          for_element(element, max_left_offset, max_top_offset, max_right_offset, max_bottom_offset)
        else
          raise Applitools::EyesIllegalArgument.new "Unsupported element - #{element.class}"
        end
      end

      def for_element(element, max_left_offset, max_top_offset, max_right_offset, max_bottom_offset)
        new element.location.x, element.location.y, element.size.width, element.size.height, max_left_offset,
          max_top_offset, max_right_offset, max_bottom_offset
      end
      private :for_element
    end

    attr_accessor :max_top_offset, :max_right_offset, :max_bottom_offset, :max_left_offset

    def initialize(left, top, width, height, max_left_offset, max_top_offset, max_right_offset, max_bottom_offset)
      super(left, top, width, height)
      self.max_left_offset = max_left_offset
      self.max_top_offset = max_top_offset
      self.max_right_offset = max_right_offset
      self.max_bottom_offset = max_bottom_offset
    end

    def to_hash
      {
        'Top' => top,
        'Left' => left,
        'Width' => width,
        'Height' => height,
        'MaxUpOffset' => max_top_offset,
        'MaxLeftOffset' => max_left_offset,
        'MaxRightOffset' => max_right_offset,
        'MaxDownOffset' => max_bottom_offset
      }
    end
  end
end
