module Applitools::Selenium
  # @!visibility private
  class ScrollPositionProvider
    extend Forwardable

    def_delegators 'Applitools::EyesLogger', :logger, :log_handler, :log_handler=

    def initialize(executor, disable_horizontal = false, disable_vertical = false)
      self.executor = executor
      self.disable_horizontal = disable_horizontal
      self.disable_vertical = disable_vertical
    end

    # The scroll position of the current frame
    def current_position
      logger.info 'current_position()'
      result = Applitools::Utils::EyesSeleniumUtils.current_scroll_position(executor)
      logger.info "Current position: #{result}"
      result
    rescue Applitools::EyesDriverOperationException
      raise 'Failed to extract current scroll position!'
    end

    def state
      current_position
    end

    def restore_state(value)
      self.position = value
    end

    def position=(value)
      logger.info "Scrolling to #{value}"
      Applitools::Utils::EyesSeleniumUtils.scroll_to(executor, value)
      logger.info 'Done scrolling!'
    end

    alias scroll_to position=

    def entire_size
      viewport_size = Applitools::Utils::EyesSeleniumUtils.extract_viewport_size(executor)
      result = Applitools::Utils::EyesSeleniumUtils.entire_page_size(executor)
      logger.info "Entire size: #{result}"
      result.width = viewport_size.width if disable_horizontal
      result.height = viewport_size.height if disable_vertical
      result
    end

    def force_offset
      Applitools::Location.new(0, 0)
    end

    private

    attr_accessor :executor, :disable_horizontal, :disable_vertical
  end
end
