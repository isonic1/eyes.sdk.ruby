module Applitools
  module Calabash
    class Eyes < Applitools::Images::Eyes
      attr_accessor :density
      attr_reader :context

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

      def add_context(value)
        @context = value
      end

      def remove_context
        @context = nil
      end

      def capture_screenshot
        Applitools::Calabash::Utils.using_screenshot(context) do |screenshot_path|
          self.screenshot = screenshot_class.new(
            Applitools::Screenshot.from_image(
              ::ChunkyPNG::Image.from_file(screenshot_path)
            ),
            scale_factor: density
          )
        end
        screenshot
      end

      def screenshot_class
        env = Applitools::Calabash::EnvironmentDetector.current_environment
        case env
          when :android
            Applitools::Calabash::EyesCalabashAndroidScreenshot
          when :ios
            Applitools::Calabash::EyesCalabashIosScreenshot
        end
      end

      def check_it(name, target, match_window_data)
        Applitools::ArgumentGuard.not_nil(name, 'name')
        region_provider = get_region_provider(target)

        match_window_data.tag = name
        update_default_settings(match_window_data)
        match_window_data.read_target(target, nil)

        self.viewport_size = Applitools::Calabash::EyesSettings.instane.viewport_size if viewport_size.nil?

        if match_window_data.is_a? Applitools::MatchSingleCheckData
          return check_single_base(
              region_provider,
              target.options[:timeout] || Applitools::EyesBase::USE_DEFAULT_TIMEOUT,
              match_window_data
          )
        end

        check_window_base(
            region_provider,
            target.options[:timeout] || Applitools::EyesBase::USE_DEFAULT_TIMEOUT,
            match_window_data
        )
      end

      def get_region_provider(target)
        if (region_to_check = target.region_to_check).nil?
          Object.new.tap do |prov|
            prov.instance_eval do
              define_singleton_method :region do
                Applitools::Region::EMPTY
              end

              define_singleton_method :coordinate_type do
                nil
              end
            end
          end
        else
          Object.new.tap do |prov|
            prov.instance_eval do
              define_singleton_method :region do
                region_to_check.region
              end
              define_singleton_method :coordinate_type do
                Applitools::Calabash::EyesCalabashScreenshot::DRIVER
              end
            end
          end
        end
      end
    end
  end
end