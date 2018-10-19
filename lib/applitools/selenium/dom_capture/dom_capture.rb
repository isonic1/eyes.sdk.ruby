# frozen_string_literal: false

require 'css_parser'
module Applitools::Selenium
  module DomCapture
    extend self

    def get_window_dom(driver, logger)
      args_obj = {
        'styleProps' => [],
        'attributeProps' => nil,
        'rectProps' => %w(width height top left bottom right),
        'ignoredTagNames' => %w(HEAD SCRIPT)
      }
      dom_tree = driver.execute_script(Applitools::Selenium::DomCapture::DOM_CAPTURE_SCRIPT, args_obj)
      get_frame_dom(driver, {'childNodes' => [dom_tree], 'tagName' => 'OUTER_HTML'}, logger)
      dom_tree
    end

    private

    def get_frame_dom(driver, dom_tree, logger)
      tag_name = dom_tree['tagName']
      return unless tag_name
      frame_index = 0
      loop(driver, dom_tree, logger) do |dom_sub_tree|
        #this block is called if IFRAME found
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
      driver.execute_script(Applitools::Selenium::DomCapture::CSS_CAPTURE_SCRIPT).each do |item|
        if (v = item['text'])
          parser.add_block!(v)
        elsif (v = item['href'])
          begin
            target_url = URI.parse(v)
            url_to_load = target_url.absolute? ? target_url : base_url.merge(target_url)
            parser.load_uri!(url_to_load)
          rescue CssParser::CircularReferenceError
            logger.respond_to?(:error) && logger.error("Got a circular reference error! #{url_to_load}")
          rescue CssParser::RemoteFileError
            nil
          end
        end
      end
      css_result = ''
      parser.each_rule_set { |s| css_result.concat(s.to_s) }
      css_result
    end
  end
end
