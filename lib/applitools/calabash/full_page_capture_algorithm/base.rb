module Applitools
  module Calabash
    module FullPageCaptureAlgorithm
      class Base
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
      end
    end
  end
end