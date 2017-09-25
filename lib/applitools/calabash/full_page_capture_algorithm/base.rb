module Applitools
  module Calabash
    module FullPageCaptureAlgorithm
      class Base
        class << self
          include Applitools::Helpers
        end
        extend Forwardable
        def_delegators 'Applitools::EyesLogger', :logger, :log_handler, :log_handler=

        attr_reader :context, :element, :screenshot_provider

        DEFAULT_SLEEP_INTERVAL = 1

        def initialize(screenshot_provider, element)
          Applitools::ArgumentGuard.is_a?(element, 'element', Applitools::Calabash::CalabashElement)
          @screenshot_provider = screenshot_provider
          @element = element
          @context = screenshot_provider.context
        end

        private

        def create_entire_image
          current_entire_size = entire_size
          @stitched_image = ::ChunkyPNG::Image.new(current_entire_size.width, current_entire_size.height)
        end

        def entire_content
          @entire_content ||= scrollable_element
        end

        def entire_size
          entire_content.size
        end

        define_abstract_method(:scrollable_element, true)
      end
    end
  end
end
