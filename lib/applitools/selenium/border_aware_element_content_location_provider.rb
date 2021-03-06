# frozen_string_literal: true

module Applitools::Selenium
  # @!visibility private
  class BorderAwareElementContentLocationProvider
    extend Forwardable

    def_delegators 'Applitools::EyesLogger', :logger, :log_handler, :log_handler=

    attr_accessor :element, :location, :size

    # Initialize class instance.
    #
    # @param [Applitools::Selenium::Element] element The target element.
    def initialize(element)
      raise Applitools::EyesIllegalArgument.new 'Passed element is not Applitools::Selenium::Element instance!' unless
          element.is_a? Applitools::Selenium::Element
      self.element = element
      self.location = Applitools::Location.for element.location
      self.size = Applitools::RectangleSize.for element.size
      calculate_location_size
    end

    private

    def calculate_location_size
      border_left = element.border_left_width
      border_right = element.border_right_width
      border_top = element.border_top_width
      border_bottom = element.border_bottom_width

      padding_left = element.padding_left_width
      padding_right = element.padding_right_width
      padding_top = element.padding_top_width
      padding_bottom = element.padding_bottom_width

      location.offset Applitools::Location.new(border_left + padding_left, border_top + padding_top)
      size - Applitools::RectangleSize.new(padding_left + padding_right + border_left + border_right,
        padding_top + padding_bottom + border_top + border_bottom)

    rescue Applitools::EyesDriverOperationException
      self.location = Applitools::Location.for element.location
      self.size = Applitools::RectangleSize.for element.size
    end
  end
end
