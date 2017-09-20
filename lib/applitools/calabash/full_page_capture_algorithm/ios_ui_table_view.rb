require_relative 'base'

module Applitools
  module Calabash
    module FullPageCaptureAlgorithm
      class IosUITableView < Base
        attr_reader :stitched_image

        def initialize(*args)
          super
          @entire_content = nil
          @stitched_image = nil
          @original_position = nil
        end
      end
    end
  end
end
