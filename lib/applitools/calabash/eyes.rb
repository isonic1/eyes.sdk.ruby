module Applitools
  module Calabash
    class Eyes < Applitools::Images::Eyes
      attr_accessor :density

      def initialize(server_url = Applitools::Connectivity::ServerConnector::DEFAULT_SERVER_URL)
        super
        self.base_agent_id = "eyes.calabash.ruby/#{Applitools::VERSION}".freeze
      end

      def check(name, target)
        check_it(name, target, Applitools::MatchWindowData.new)
      end

      def inferred_environment
        return @inferred_environment unless @inferred_environment.nil?
        return unless density
        "density: #{density}"
      end

      def capture_screenshot

      end

      def check_it

      end
    end
  end
end