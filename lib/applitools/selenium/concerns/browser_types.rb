module Applitools
  module Selenium
    module Concerns
      module BrowserTypes
        extend self
        CHROME = :chrome
        FIREFOX = :firefox

        def enum_values
          [CHROME, FIREFOX]
        end
      end
    end
  end
end