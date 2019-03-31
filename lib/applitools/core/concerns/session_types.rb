module Applitools
  module Concerns
    module SessionTypes
      extend self
      SEQUENTIAL = 'SEQUENTIAL'
      PROGRESSION = 'PROGRESSION'

      def enum_values
        [SEQUENTIAL, PROGRESSION]
      end
    end
  end
end