# frozen_string_literal: false

require 'benchmark'
require 'timeout'

require 'css_parser'
include Benchmark
module Applitools::Selenium
  module DomCapture
    CSS_DOWNLOAD_TIMEOUT = 2 # 2 seconds

    extend self

    def get_window_dom(driver, logger)
      args_obj = {
        'styleProps' => %w(
          background-color background-image background-size color border-width
          border-color border-style padding margin
        ),
        'attributeProps' => nil,
        'rectProps' => %w(width height top left),
        'ignoredTagNames' => %w(HEAD SCRIPT)
      }
      dom_tree = driver.execute_script(Applitools::Selenium::DomCapture::DOM_CAPTURE_SCRIPT, args_obj)
      get_frame_dom(driver, { 'childNodes' => [dom_tree], 'tagName' => 'OUTER_HTML' }, logger)
      dom_tree
    end

    private

    def get_frame_dom(driver, dom_tree, logger)
      tag_name = dom_tree['tagName']
      return unless tag_name
      frame_index = 0
      loop(driver, dom_tree, logger) do |dom_sub_tree|
        # this block is called if IFRAME found
        driver.switch_to.frame(index: frame_index)
        get_frame_dom(driver, dom_sub_tree, logger)
        driver.switch_to.parent_frame
        frame_index += 1
      end
    end

    def loop(driver, dom_tree, logger)
      child_nodes = dom_tree['childNodes']
      return unless child_nodes
      iterate_child_nodes = proc do |node_childs|
        node_childs.each do |node|
          if node['tagName'].casecmp('IFRAME') == 0
            yield(node) if block_given?
          else
            node['css'] = get_frame_bundled_css(driver, logger) if node['tagName'].casecmp('HTML') == 0
            iterate_child_nodes.call(node['childNodes']) unless node['childNodes'].nil?
          end
        end
      end
      iterate_child_nodes.call(child_nodes)
    end

    def get_frame_bundled_css(driver, logger)
      base_url = URI.parse(driver.current_url)
      parser = CssParser::Parser.new import: true, absolute_paths: true
      css_threads = []
      css_items = []
      driver.execute_script(Applitools::Selenium::DomCapture::CSS_CAPTURE_SCRIPT).each_with_index do |item, i|
        if (v = item['text'])
          css_items[i] = [v]
        elsif (v = item['href'])
          target_url = URI.parse(v)
          url_to_load = target_url.absolute? ? target_url : base_url.merge(target_url)
          css_threads << Thread.new(url_to_load) do |url|
            if Timeout.respond_to?(:timeout)
              Timeout.timeout(CSS_DOWNLOAD_TIMEOUT) do
                css_string, = parser.send(:read_remote_file, url)
                css_items[i] = [css_string, { base_uri: url }]
              end
            else
              timeout(CSS_DOWNLOAD_TIMEOUT) do
                css_string, = parser.send(:read_remote_file, url)
                css_items[i] = [css_string, { base_uri: url }]
              end
            end
          end
        end
      end
      begin
        css_threads.each(&:join)
      rescue CssParser::CircularReferenceError => e
        logger.respond_to?(:error) && logger.error("Got a circular reference error! #{e.message}")
      rescue CssParser::RemoteFileError => e
        logger.respond_to?(:error) && logger.error("File download error - #{e.message}")
      rescue StandardError => e
        logger.respond_to?(:error) && logger.error("#{e.class} - #{e.message}")
      end

      css_items.each { |css| parser.add_block!(*css) if css && css[0] }
      css_result = ''
      parser.each_rule_set { |s| css_result.concat(s.to_s) }
      css_result
    end
  end
end
