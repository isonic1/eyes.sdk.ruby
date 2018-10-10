require 'css_parser'
module Applitools::Selenium
  module DomCapture
    extend self

    def get_full_window_dom(driver, logger)

    end

    def get_window_dom(driver, logger)
      args_obj = {
        "styleProps" => [
         "background-color",
         "background-image",
         "background-size",
         "color",
         "border-width",
         "border-color",
         "border-style",
         "padding",
         "margin"
        ],
        "attributeProps" => {
          "all" => [ "id", "class" ],
          "IMG" => ["src" ],
          "IFRAME" => ["src"],
          "A" => ["href"],
        },
        "rectProps" => [
          "width",
          "height",
          "top",
          "left",
          "bottom",
          "right"
        ],
        "ignoredTagNames" => [
          "HEAD",
          "SCRIPT"
        ]
      }
      get_frame_dom(driver, args_obj, logger)
    end

    private

    def get_frame_dom(driver, args_obj, logger)
      dom_tree = driver.execute_script(Applitools::Selenium::DomCapture::DOM_CAPTURE_SCRIPT, args_obj)
      traverse_dom_tree(driver, args_obj, dom_tree, -1, logger)
    end

    def traverse_dom_tree(driver, args_obj, dom_tree, frame_index, logger)
      tag_name = dom_tree['tagName']
      return unless tag_name

      if frame_index > -1
        driver.switch_to.frame(frame_index)
        dom = driver.execute_script(Applitools::Selenium::DomCapture::DOM_CAPTURE_SCRIPT, args_obj)
        dom_tree['childNodes'] = dom
        src_url = dom_tree['attributes'] && dom_tree['attributes']['src']
        logger.respond_to?(:warn) && logger.warn('WARNING! The iframe with no src!') unless src_url
        traverse_dom_tree(driver, args_obj, dom, -1, src_url, logger)
        driver.switch_to.parent_frame
      end

      dom_tree['css'] = get_frame_bundled_css(driver, logger) if tag_name.upcase == 'HTML'

      loop(driver, args_obj, dom_tree, logger)
      dom_tree
    end

    def loop(driver, args_obj, dom_tree, logger)
      child_nodes = dom_tree['childNodes']
      return unless child_nodes
      index = 0
      child_nodes.each do |node|
        if node['tagName'].upcase == 'IFRAME'
          traverse_dom_tree(driver, args_obj, node, index, logger)
          index += 1
        end
      end
    end

    def get_frame_bundled_css(driver, logger)
      base_url = URI.parse(driver.current_url)
      parser = CssParser::Parser.new import: true, absolute_paths: true
      driver.execute_script(Applitools::Selenium::DomCapture::CSS_CAPTURE_SCRIPT).each do |item|
        if (v = item['text'])
          parser.add_block!(v)
        elsif(v = item['href'])
          begin
            target_url = URI.parse(v)
            url_to_load = target_url.absolute? ? target_url : base_url.merge(target_url)
            parser.load_uri!(url_to_load)
          rescue  CssParser::CircularReferenceError
            logger.respond_to?(:error) && logger.error("Got a circular reference error! #{url_to_load}")
          end
        end
      end
      css_result = ''
      parser.each_rule_set() {|s| css_result.concat(s.to_s)}
      css_result
    end
  end
end
