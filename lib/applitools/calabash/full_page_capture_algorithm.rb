Applitools::Calabash.require_dir 'calabash/full_page_capture_algorithm'

module Applitools
  module Calabash
    module FullPageCaptureAlgorithm
      ALGORITHMS = {
        "android.widget.ScrollView" => Applitools::Calabash::FullPageCaptureAlgorithm::AndroidScrollView
      }.freeze
      class << self
        def get_algorithm_class(klass)
          ALGORITHMS[klass]
        end
      end
    end
  end
end