 module Applitools
   module Selenium
     module Concerns
       class BrowsersInfo < Set
         def add(obj)
           return super if obj.is_a? Applitools::Selenium::RenderBrowserInfo
           raise(
             Applitools::EyesIllegalArgument,
             "It is expected the value to be an Applitools::Selenium::RenderBrowserInfo instance," \
             " but got #{obj.class} instead"
           )
         end
       end
     end
   end
 end