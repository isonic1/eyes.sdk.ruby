require_relative 'base'
module Applitools
  module Calabash
    module FullPageCaptureAlgorithm
      class AndroidScrollView < Base
        attr_reader :stitched_image
        def initialize(*args)
          super
          @entire_content = nil
          @stitched_image = nil
        end

        def get_stitched_region
          create_entire_image
          scroll_top

          require 'pry'
          binding.pry
        end

        private

        def entire_content
          @entire_content ||= get_scrollable_element
        end

        def get_scrollable_element
          child_query = "#{element.element_query} child index:0"
          Applitools::Calabash::Utils.get_android_element(context, child_query, 0)
        end

        def get_entire_size
          entire_content.size
        end

        def scroll_top

        end

        def croll_down_once

        end

        def create_entire_image
          entire_size = get_entire_size
          @stitched_image = ::ChunkyPNG::Image.new(entire_size.width, entire_size.height)
        end
      end
    end
  end
end