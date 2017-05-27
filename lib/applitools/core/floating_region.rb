require_relative 'region'
module Applitools
  class FloatingRegion < Region
    class << self
      def for_element(element, max_left_offset, max_top_offset, max_right_offset, max_bottom_offset)
        Applitools::ArgumentGuard.is_a? element, 'element', Applitools::Selenium::Element
        new element.location.x, element.location.y, element.size.width, element.size.height, max_left_offset,
          max_top_offset, max_right_offset, max_bottom_offset
      end
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
