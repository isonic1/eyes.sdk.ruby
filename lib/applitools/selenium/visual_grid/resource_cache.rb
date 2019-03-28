require 'thread'
module Applitools
  module Selenium
    class ResourceCache
      attr_accessor :cache_map, :semaphore

      def initialize
        self.cache_map = {}
        self.semaphore = Mutex.new
      end

      def contains?(url)
        semaphore.synchronize do
          cache_map.keys.include?(url) && !cache_map[url].nil?
        end
      end

      def [](key)
        current_value = semaphore.synchronize do
          cache_map[key]
        end
        return current_value unless cache_map[key].is_a? Applitools::Future
        update_cache_map(key, cache_map[key].get)
      end

      def []=(key, value)
        Applitools::ArgumentGuard.is_a?(key, 'key', URI)
        Applitools::ArgumentGuard.one_of?(value, 'value', [Applitools::Future, Applitools::Selenium::VGResource])
        update_cache_map(key, value)
      end

      def fetch_and_store(key, &block)
        return self[key] if self.contains? key
        return unless block_given?
        self[key] = Applitools::Future.new(semaphore) do |semaphore|
          block.call(semaphore)
        end
        return true if cache_map[key].is_a? Applitools::Future
        false
      end

      private

      def update_cache_map(key, value)
        semaphore.synchronize do
          cache_map[key] = value
        end
      end
    end
  end
end