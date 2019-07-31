module Applitools
  module Selenium
    class Eyes < SimpleDelegator

      def initialize(*args)
        options = Applitools::Utils.extract_options!(args)
        server_url = options.delete(:server_url)
        server_url = args.first unless server_url
        runner = options.delete(:visual_grid_runner)
        if runner.is_a? Applitools::Selenium::VisualGridRunner
          super Applitools::Selenium::VisualGridEyes.new(runner, server_url)
        else
          super Applitools::Selenium::SeleniumEyes.new(server_url)
        end
      end

    end
  end
end