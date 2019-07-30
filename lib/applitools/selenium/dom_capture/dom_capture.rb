module Applitools
  module Selenium
    module DomCapture
      extend self
      DOM_EXTRACTION_TIMEOUT = 300 #seconds
      def full_window_dom(driver, logger, position_provider = nil)
        return get_dom(driver, logger) unless position_provider
        scroll_top_and_return_back(position_provider) do
          get_dom(driver, logger)
        end
      end

      def get_dom(driver, logger)
        original_frame_chain = driver.frame_chain
        dom = get_frame_dom(driver, logger)
        unless original_frame_chain.empty?
          driver.switch_to.default_content
          driver.switch_to.frames(frame_chain: original_frame_chain)
        end
        # CSS processing

        dom
      end

      def get_frame_dom(driver, logger)
        result = ''
        logger.info 'Trying to get DOM from driver'
        start_time = Time.now
        script_response = nil
        loop do
          result_as_string = driver.execute_script(CAPTURE_FRAME_SCRIPT + ' return __captureDomAndPoll();')
          script_response = Oj.load(result_as_string)
          status = script_response['status']
          break if status == 'SUCCESS'
          raise Applitools::EyesError, 'DOM extraction timeout!' if Time.now - start_time > DOM_EXTRACTION_TIMEOUT
          raise Applitools::EyesError, "DOM extraction error: #{script_response['error']}" if script_response['error']
          sleep(0.2)
        end
        response_lines = script_response['value'].split /\r?\n/
        separators = Oj.load(response_lines.shift)
        missing_css_list = []
        missing_frame_list = []
        data = []

        puts separators

        blocks = DomParts.new(missing_css_list, missing_frame_list, data)
        collector = blocks.collectors.next
        response_lines.each do |line|
          if line == separators['separator']
            collector = blocks.collectors.next
          else
            collector << line
          end
        end
        logger.info "Missing CSS: #{missing_css_list.count}"
        logger.info "Missing frames: #{missing_frame_list.count}"
        #fetch_css_files(missing_css_list)

        frame_data = recurse_frames(driver, logger, missing_frame_list)
        result = replace(separators['iframeStartToken'], separators['iframeEndToken'], data.first, frame_data)

        css_data = fetch_css_files(missing_css_list)
        replace(separators['cssStartToken'], separators['cssEndToken'], result, css_data)
      rescue StandardError
        logger.error(e.class)
        logger.error(e.message)
        logger.error(e)
        return ''
      end

      def fetch_css_files(missing_css_list)
        result = {}
        missing_css_list.each do |url|
          next if url.empty?
          next if /^blob:/ =~ url

          begin
            parser = CssParser::Parser.new(absolute_paths: true, import: true)
            parser.load_uri!(url)
            css = ''
            parser.each_rule_set do |s|
              css += s.to_s
            end
            result[url] = css
          rescue StandardError
            result[url] = ''
          end
        end
        result
      end

      def recurse_frames(driver, logger, missing_frame_list)
        return if missing_frame_list.empty?
        frame_data = {}
        frame_chain = driver.frame_chain
        origin_location = driver.execute_script('return document.location.href')
        missing_frame_list.each do |missing_frame_line|
          logger.info "Switching to frame line: #{missing_frame_line}"
          missing_frame_line.split(/,/).each do |xpath|
            logger.info "switching to specific frame: #{xpath}"
            frame_element = driver.find_element(:xpath, xpath)
            frame_src = frame_element.attribute('src')
            driver.switch_to.frame(frame_element)
            logger.info "Switched to frame ( #{xpath} ) with src( #{frame_src} )"
          end
          location_after_switch = driver.execute_script('return document.location.href')

          if origin_location == location_after_switch
            logger.info "Switch to frame (#{missing_frame_line}) failed"
            frame_data[missing_frame_line] = ''
          else
            result = get_frame_dom(driver, logger)
            frame_data[missing_frame_line] = result
          end
        end
        driver.switch_to.default_content
        driver.switch_to.frames(frame_chain: frame_chain)
        frame_data
      end

      def scroll_top_and_return_back(position_provider)
        original_position = position_provider.current_position
        position_provider.scroll_to Applitools::Location.new(0, 0)
        result = yield if block_given?
        position_provider.scroll_to original_position
        result
      end

      def replace(open_token, close_token, input, replacements)
        pattern = /#{open_token}(?<key>.+?)#{close_token}/
        input.gsub(pattern) { |_m| replacements[Regexp.last_match(1)] }
      end

      class DomParts
        attr_accessor :dom_part_collectors
        def initialize(*args)
          self.dom_part_collectors = args
          @index = 0
        end

        def collectors
          @collectors ||= Enumerator.new(dom_part_collectors.length) do |y|
            loop do
              y << dom_part_collectors[@index]
              @index += 1
            end
          end
        end
      end
    end
  end
end
