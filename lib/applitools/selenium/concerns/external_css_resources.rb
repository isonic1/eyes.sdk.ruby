require 'css_parser'
require 'pry'

module Applitools
  module Selenium
    module Concerns
      class ExternalCssResources
        include CssParser
        def initialize(url, base_url = nil)
          @parser = CssParser::Parser.new(absolute_paths: true)
          @parser.load_uri!(url)
          @parser.compact!
        end

        def flatten_rules
          @flatten ||= flatten_hash(hash, 0)
        end

        def hash
          @h ||= @parser.to_h
        end

        def images
          result = []
          @parser.each_rule_set { |s| s.expand_background_shorthand!; result.push(s) unless s.get_value('background-image').empty? }
          result
        end
      end
    end
  end
end