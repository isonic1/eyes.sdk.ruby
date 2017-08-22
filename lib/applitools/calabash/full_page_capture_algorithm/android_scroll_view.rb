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

          scroll_while_possible do |scrollable_element|
            put_it_on_canvas!(
              screenshot_provider.capture_screenshot.sub_screenshot(
                eyes_window,
                Applitools::Calabash::EyesCalabashScreenshot::DRIVER,
                false,
                false
              ).image,
            element.location.offset_negative(scrollable_element.location)
            )
          end

          scroll_top

          Applitools::Calabash::EyesCalabashAndroidScreenshot.new(
            Applitools::Screenshot.from_image(stitched_image),
            density: screenshot_provider.density
          )
        end

        private

        def put_it_on_canvas!(image, offset)
          stitched_image.replace!(image, offset.x, offset.y)
        end

        def entire_content
          @entire_content ||= get_scrollable_element
        end

        def get_scrollable_element
          child_query = "#{element.element_query} child * index:0"
          Applitools::Calabash::Utils.get_android_element(context, child_query, 0)
        end

        def get_entire_size
          entire_content.size
        end

        def scroll_top
          logger.info 'Scrolling up...'
          scroll_while_possible(:up)
          logger.info 'Done!'
        end

        def scroll_down_once
          context.scroll(element.element_query, :down)
        end

        def scroll_up_once
          context.scroll(element.element_query, :up)
        end

        def scroll_while_possible(direction = :down)
          previous_y_pos = nil
          while (element = get_scrollable_element).top != previous_y_pos
            yield(element) if block_given?
            previous_y_pos = element.top
            direction == :up ? scroll_up_once : scroll_down_once
            sleep DEFAULT_SLEEP_INTERVAL
          end
        end

        def create_entire_image
          entire_size = get_entire_size
          @stitched_image = ::ChunkyPNG::Image.new(entire_size.width, entire_size.height)
        end

        def eyes_window
          @eyes_window ||= Applitools::Region.from_location_size(element.location, element.size)
        end
      end
    end
  end
end