module Applitools
  module Selenium
    class VisualGridRunner
      EMPTY_QUEUE = []
      attr_accessor :all_eyes, :resource_cache, :put_cache, :rendering_info

      def initialize(concurrent_open_sessions = 10)
        self.all_eyes = []
        @thread_pool = Applitools::Selenium::VGThreadPool.new(concurrent_open_sessions)
        self.resource_cache = Applitools::Selenium::ResourceCache.new
        self.put_cache = Applitools::Selenium::ResourceCache.new
        init
      end

      def init
        @thread_pool.on_next_task_needed do
          (task = get_task_queue.pop).is_a?(Applitools::Selenium::VGTask) ? task : nil
        end
        @thread_pool.start
      end

      def open(eyes)
        all_eyes << eyes
      end

      def stop
        while all_running_tests.map(&:score).reduce(0, :+) > 0 do
          sleep 0.5
        end
        @thread_pool.stop
      end

      def rendering_info(connector)
        @rendering_info ||= connector.rendering_info
      end

      def get_all_test_results
        while !(all_eyes.select {|e| e.open?}.empty?)
          sleep 0.5
        end
        all_eyes.map { |e| e.test_list.map(&:test_result) }.flatten
      end

      private

      def all_running_tests
        all_eyes.collect { |e| e.test_list }.flatten
      end

      def all_running_tests_by_score
        all_running_tests.sort { |x, y| y.score <=> x.score }
      end

      def get_task_queue
        test_to_run = all_running_tests_by_score.first
        test_to_run ? test_to_run.queue : EMPTY_QUEUE
      end
    end
  end
end