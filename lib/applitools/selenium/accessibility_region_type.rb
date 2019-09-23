# frozen_string_literal: true

module Applitools
  module Selenium
    module AccessibilityRegionType
      extend self

      NONE = 'None'
      REGULAR_TEXT = 'RegularText'
      LARGE_TEXT = 'LargeText'
      BOLD_TEXT = 'BoldText'
      ESSENTIAL_IMAGE = 'EssentialImage'
      DISABLED_OR_INACTIVE = 'DisabledOrInactive'
      NON_ESSENTIAL_IMAGE = 'NonEssentialImage'
      LOGO = 'Logo'
      BACKGROUND = 'Background'
      IGNORE = 'Ignore'

      def enum_values
        [
          NONE,
          REGULAR_TEXT,
          LARGE_TEXT,
          BOLD_TEXT,
          ESSENTIAL_IMAGE,
          DISABLED_OR_INACTIVE,
          NON_ESSENTIAL_IMAGE,
          LOGO,
          IGNORE
        ]
      end
    end
  end
end