module Applitools
  class MatchWindowData
    class << self
      def default_data
        {
          'IgnoreMismatch' => false,
          'MismatchWait' => 0,
          'Options' => {
            'Name' => nil,
            'UserInputs' => [],
            'ImageMatchSettings' => {
              'MatchLevel' => 'None',
              'SplitTopHeight' => 0,
              'SplitBottomHeight' => 0,
              'IgnoreCaret' => false,
              'Exact' => {
                'MinDiffIntensity' => 0,
                'MinDiffWidth' => 0,
                'MinDiffHeight' => 0,
                'MatchThreshold' => 0
              }
            },
            'IgnoreExpectedOutputSettings' => false,
            'ForceMatch' => false,
            'ForceMismatch' => false,
            'IgnoreMatch' => false,
            'IgnoreMismatch' => false,
            'Trim' => {
              'Enabled' => false,
              'ForegroundIntensity' => 0,
              'MinEdgeLength' => 0
            }
          },
          'Id' => nil,
          'UserInputs' => [],
          'AppOutput' => {
            'Screenshot64' => nil,
            'ScreenshotUrl' => nil,
            'Title' => nil,
            'IsPrimary' => false,
            'Elapsed' => 0
          },
          'Tag' => nil
        }
      end
    end

    attr_accessor :app_output, :user_inputs, :tag, :options, :ignore_mismatch

    def initialize(user_inputs, app_output, tag, ignore_mismatch, options = {})
      self.user_inputs = user_inputs
      self.app_output = app_output
      self.tag = tag
      self.ignore_mismatch = ignore_mismatch
      self.options = options
    end

    def screenshot
      app_output.screenshot.image.to_blob
    end

    def ignore_mismatch=(value)

    end

    def tag=(value)
      
    end

    def user_inputs=(value)

    end

    def app_output=(value)

    end



    alias appOutput app_output
    alias userInputs user_inputs
    alias ignoreMismatch ignore_mismatch

    def to_hash
      ary = [:userInputs, :appOutput, :tag, :ignoreMismatch, :options].map do |field|
        result = send(field)
        result = result.to_hash if result.respond_to? :to_hash
        [field, result] if [String, Symbol, Hash, Array, FalseClass, TrueClass].include? result.class
      end.compact
      Hash[ary]
    end

    def to_s
      to_hash
    end

    private

    def current_data
      @current_data ||= self.class.default_data
    end
  end
end
