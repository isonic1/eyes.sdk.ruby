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
      get_frame_dom(driver, args_obj, logger)
    end

    private

    def get_frame_dom(driver, args_obj, logger)
      dom_tree = driver.execute_script(Applitools::Selenium::DomCapture::DOM_CAPTURE_SCRIPT, args_obj)
      traverse_dom_tree(driver, dom_tree, logger)
    end

    def traverse_dom_tree(driver, dom_tree, logger)
      tag_name = dom_tree['tagName']
      return unless tag_name

      loop(driver, { 'childNodes' => [dom_tree] }, logger)
      dom_tree
    end

    def loop(driver, dom_tree, logger)
      child_nodes = dom_tree['childNodes']
      return unless child_nodes
      iterate_child_nodes = proc do |node_childs|
        node_childs.each do |node|
          node['css'] = get_frame_bundled_css(driver, logger) if node['tagName'].casecmp('HTML') == 0
          iterate_child_nodes.call(node['childNodes']) unless node['childNodes'].nil?
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
          end
        end
      end
      css_result = ''
      parser.each_rule_set { |s| css_result.concat(s.to_s) }
      css_result
    end
  end
end
