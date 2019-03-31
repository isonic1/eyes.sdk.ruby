require 'oj'
module Applitools
  module Selenium
    class RenderRequest
      include Applitools::Jsonable
      json_fields :renderId, :webhook, :url, :dom, :resources, :scriptHooks,
                  :selectorsToFindRegionsFor, :send_dom

      json_fields :renderInfo, :browser

      def initialize(*args)
        #String webHook, String url, RGridDom dom, Map<String, RGridResource> resources, RenderInfo renderInfo, String platform, String browserName, Object scriptHooks, String[] selectorsToFindRegionsFor, boolean sendDom, Task task
        options = Applitools::Utils.extract_options! args
        self.script_hooks = {}
        self.selectors_to_find_regions_for = []
        options.keys.each do |k|
          send("#{k}=", options[k]) if options[k] && respond_to?("#{k}=")
        end
      end
    end
  end
end