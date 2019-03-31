require 'securerandom'
module Applitools
  module Selenium
    class VGTask
      attr_accessor :name, :uuid
      def initialize(name, &block)
        self.name = name
        @block_to_run = block if block_given?
        @callback = nil
        @error_callback = nil
        @completed_callback = nil
        self.uuid = SecureRandom.uuid
      end

      def on_task_succeeded(&block)
        @callback = block if block_given?
        self
      end

      def on_task_error(&block)
        @error_callback = block if block_given?
        self
      end

      def on_task_completed(&block)
        @completed_callback = block if block_given?
        self
      end

      def call
        return unless @block_to_run.respond_to? :call
        begin
          res = @block_to_run.call
          @callback.call(res) if @callback.respond_to? :call
        rescue StandardError => e
          Applitools::EyesLogger.logger.error 'Failed to execute task!'
          Applitools::EyesLogger.logger.error e.message
          Applitools::EyesLogger.logger.error e.backtrace.join('\n\t')
          @error_callback.call(e) if @error_callback.respond_to? :call
        ensure
          @completed_callback.call if @completed_callback.respond_to? :call
        end
      end
    end
  end
end