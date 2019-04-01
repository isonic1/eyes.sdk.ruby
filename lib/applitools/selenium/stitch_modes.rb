module Applitools
  module Selenium
    module StitchModes
      extend self
      CSS = :CSS
      SCROLL = :SCROLL

      def enum_values
        [CSS, SCROLL]
      end
    end
  end
end