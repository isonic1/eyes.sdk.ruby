# frozen_string_literal: true

module Applitools
  class AppOutput
    attr_reader :title, :screenshot64, :location

    def initialize(title, screenshot64)
      @title = title
      @screenshot64 = screenshot64
      @location = Applitools::Location::TOP_LEFT
    end

    def location=(value)
      Applitools::ArgumentGuard.is_a?(value, 'location', Applitools::Location)
      @location = value
    end

    def to_hash
      {
        Title: title,
        Screenshot64: nil,
        Location: location.to_hash
      }
    end
  end
end
