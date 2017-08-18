module Applitools
  module Calabash
    module FullPageCaptureAlgorithm
      class Base
        attr_reader :context, :element, :screenshot_provider
        def initialize(screenshot_provider, element)
          Applitools::ArgumentGuard.is_a?(element, 'element', Applitools::Calabash::CalabashElement)
          @screenshot_provider = screenshot_provider
          @element = element
          @context = screenshot_provider.context
        end
      end
    end
  end
end