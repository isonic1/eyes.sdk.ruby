module Applitools
  module Selenium
    module Concerns
      module BrowserTypes
        extend self
        CHROME = :CHROME
        FIREFOX = :FIREFOX

        def enum_values
          [CHROME, FIREFOX]
        end
      end
    end
  end
end