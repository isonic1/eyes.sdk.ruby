# frozen_string_literal: true

require_relative 'jsonable'

module Applitools
  class ImageMatchSettings
    include Applitools::Jsonable
    include Applitools::MatchLevelSetter
    json_fields :accessibilityLevel, :MatchLevel, :IgnoreCaret, :IgnoreDisplacements, :Accessibility,
      :Ignore, :Floating, :Layout, :Strict, :Content, :Exact, :EnablePatterns, :UseDom,
      :SplitTopHeight, :SplitBottomHeight, :scale, :remainder

    def initialize
      self.accessibility_level = 'None'
      self.match_level = Applitools::MatchLevel::STRICT
      self.split_top_height = 0
      self.split_bottom_height = 0
      self.ignore_caret = true
      self.ignore_displacements = false
      self.accessibility = []
      self.ignore = []
      self.floating = []
      self.layout = []
      self.strict = []
      self.content = []
      self.exact = Exact.new
      self.scale = 0
      self.remainder = 0
      self.enable_patterns = false
      self.use_dom = false
    end

    def set_match_level(value, exact_options = {})
      (self.match_level, self.exact) = match_level_with_exact(value, exact_options)
      match_level
    end

    def deep_dup
      cloned_value = self.class.new
      self.class.json_methods.keys.each do |f|
        new_value = case (v = send(f))
                    when Symbol, FalseClass, TrueClass, Integer, Float
                      v
                    else
                      v.clone
                    end
        cloned_value.send("#{f}=", new_value)
      end
      cloned_value
    end

    class Exact
      include Applitools::Jsonable
      json_fields :MinDiffIntensity, :MinDiffWidth, :MinDiffHeight, :MatchThreshold

      class << self
        def from_exact_options(options)
          new.tap do |exact|
            exact.min_diff_intensity = options['MinDiffIntensity']
            exact.min_diff_width = options['MinDiffWidth']
            exact.min_diff_height = options['MinDiffHeight']
            exact.match_threshold = options['MatchThreshold']
          end
        end
      end

      def initialize
        self.min_diff_intensity = 0
        self.min_diff_width = 0
        self.min_diff_height = 0
        self.match_threshold = 0
      end

      def ==(other)
        min_diff_intensity == other.min_diff_intensity &&
          min_diff_width == other.min_diff_width &&
          min_diff_height == other.min_diff_height &&
          match_threshold == other.match_threshold
      end
    end
  end
end
