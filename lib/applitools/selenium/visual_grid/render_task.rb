require 'base64'
require 'applitools/selenium/visual_grid/vg_task'

module Applitools
  module Selenium
    class RenderTask < VGTask
      include Applitools::Jsonable
      MAX_FAILS_COUNT = 5
      MAX_ITERATIONS = 100

      attr_accessor :script, :running_tests, :all_blobs, :resource_urls, :resource_cache, :put_cache, :server_connector,
        :rendering_info, :request_resources, :dom_url_mod, :result, :region_selectors, :size_mode,
        :region_to_check, :script_hooks, :visual_grid_manager

      def initialize(name, script_result, visual_grid_manager, server_connector, region_selectors, size_mode, region, script_hooks, mod = nil)
        self.result = nil
        self.script = script_result
        self.visual_grid_manager = visual_grid_manager
        self.server_connector = server_connector
        self.resource_cache = visual_grid_manager.resource_cache
        self.put_cache = visual_grid_manager.put_cache
        self.rendering_info = visual_grid_manager.rendering_info(server_connector)
        self.region_selectors = region_selectors
        self.size_mode = size_mode
        self.region_to_check = region
        self.script_hooks = script_hooks if script_hooks.is_a?(Hash)

        self.dom_url_mod = mod
        self.running_tests = []
        super(name) do
          perform
        end
      end

      def perform
        rq = prepare_data_for_rg(script_data)
        fetch_fails = 0
        begin
          response = nil
          begin
            response = server_connector.render(rendering_info['serviceUrl'], rendering_info['accessToken'], rq)
          # rescue StandardError => _e
          #   response = server_connector.render(rendering_info['serviceUrl'], rendering_info['accessToken'], requests)
          rescue StandardError => e
            Applitools::EyesLogger.error(e.message)
            fetch_fails += 1
            sleep 2
          end
          next unless response
          need_more_dom = false
          need_more_resources = false

          response.each_with_index do |running_render, index|
            rq[index].render_id = running_render['renderId']
            need_more_dom = running_render['needMoreDom']
            need_more_resources = running_render['renderStatus'] == 'need-more-resources'

            dom_resource = rq[index].dom.resource

            cache_key = URI(dom_resource.url)
            cache_key.query = "modifier=#{dom_url_mod}" if dom_url_mod

            if need_more_resources
              running_render['needMoreResources'].each do |resource_url|
                put_cache.fetch_and_store(URI(resource_url)) do |_s|
                  server_connector.render_put_resource(
                    rendering_info['serviceUrl'],
                    rendering_info['accessToken'],
                    request_resources[URI(resource_url)],
                    running_render
                  )
                end
              end
            end

            if need_more_dom
              put_cache.fetch_and_store(cache_key) do |_s|
                server_connector.render_put_resource(
                  rendering_info['serviceUrl'],
                  rendering_info['accessToken'],
                  dom_resource,
                  running_render
                )
              end
              put_cache[cache_key]
            end
          end

          still_running = need_more_resources || need_more_dom || fetch_fails > MAX_FAILS_COUNT
        end while still_running
        statuses = poll_render_status(rq)
        raise Applitools::EyesError, "Render failed for #{statuses.first['renderId']} with the message: " \
          "#{statuses.first['error']}" if statuses.first['status'] == 'error'
        self.result = statuses.first
        statuses
      end

      def poll_render_status(rq)
        iterations = 0
        statuses = []
        begin
          fails_count = 0
          proc = proc do
            server_connector.render_status_by_id(
              rendering_info['serviceUrl'],
              rendering_info['accessToken'],
              Oj.dump(json_value(rq.map(&:render_id)))
            )
          end
          begin
            statuses = proc.call
            fails_count = 0
          rescue StandardError => _e
            sleep 1
            fails_count += 1
          ensure
            iterations += 1
            sleep 0.5
          end while(fails_count > 0 and fails_count < 3)
          finished = !statuses.map { |s| s['status'] }.uniq.include?('rendering') || iterations > MAX_ITERATIONS
        end while(!finished)
        statuses
      end

      def script_data
        # @script_data ||= Oj.load script
        @script_data ||= script
      end

      def prepare_data_for_rg(data)
        self.all_blobs = data["blobs"]
        self.resource_urls = data["resourceUrls"]
        self.request_resources = Applitools::Selenium::RenderResources.new

        all_blobs.map { |blob| Applitools::Selenium::VGResource.parse_blob_from_script(blob)}.each do |blob|
          request_resources[blob.url] = blob
        end

        resource_urls.each do |url|
          resource_cache.fetch_and_store(URI(url)) do |s|
            resp_proc = proc { |u| server_connector.download_resource(u) }
            retry_count = 3
            begin
              retry_count -= 1
              response = resp_proc.call(url)
            end while response.status != 200 && retry_count > 0
            s.synchronize do
              Applitools::Selenium::VGResource.parse_response(url, response)
            end
          end
        end

        resource_urls.each do |u|
          key = URI(u)
          request_resources[key] = resource_cache[key]
        end

        requests = Applitools::Selenium::RenderRequests.new

        running_tests.each do |running_test|
          r_info = Applitools::Selenium::RenderInfo.new.tap do |r|
            r.width = running_test.browser_info.viewport_size.width
            r.height = running_test.browser_info.viewport_size.height
            r.size_mode = size_mode
            r.region = region_to_check
            r.emulation_info = running_test.browser_info.emulation_info if running_test.browser_info.emulation_info
          end

          dom = Applitools::Selenium::RGridDom.new(
              url: script_data["url"], dom_nodes: script_data['cdt'], resources: request_resources
          )

          requests << Applitools::Selenium::RenderRequest.new(
            webhook: rendering_info["resultsUrl"],
            url: script_data["url"],
            dom: dom,
            resources: request_resources,
            render_info: r_info,
            browser: {name: running_test.browser_info.browser_type, platform: running_test.browser_info.platform},
            script_hooks: script_hooks,
            selectors_to_find_regions_for: region_selectors,
            send_dom: running_test.eyes.config.send_dom.nil? ? false.to_s : running_test.eyes.config.send_dom.to_s
          )
        end
        requests
      end

      def add_running_test(running_test)
        raise Applitools::EyesError, "The running test #{running_test} already exists in the render task" if running_tests.include?(running_test)
        running_tests << running_test
        running_tests.length - 1
      end
    end
  end
end