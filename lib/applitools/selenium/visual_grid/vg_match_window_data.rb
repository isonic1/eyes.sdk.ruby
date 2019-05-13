module Applitools
  module Selenium
    class VgMatchWindowData < Applitools::MatchWindowData
      attr_accessor :target, :selector_regions
      def read_target(target, driver, selector_regions)
        self.target = target
        self.selector_regions = selector_regions
        # options
        target_options_to_read.each do |field|
          a_value = target.options[field.to_sym]
          send("#{field}=", a_value) unless a_value.nil?
        end
        # ignored regions
        if target.respond_to? :ignored_regions
          target.ignored_regions.each do |r|
            case r
            when Proc
              @ignored_regions << r.call(driver, true)
              @need_convert_ignored_regions_coordinates = true
            when Applitools::Region
              @ignored_regions << r
            end
          end
        end

        # # floating regions
        # return unless target.respond_to? :floating_regions
        # target.floating_regions.each do |r|
        #   case r
        #   when Proc
        #     region = r.call(driver, true)
        #     raise Applitools::EyesError.new "Wrong floating region: #{region.class}" unless
        #         region.is_a? Applitools::FloatingRegion
        #     @floating_regions << region
        #     @need_convert_floating_regions_coordinates = true
        #   when Applitools::FloatingRegion
        #     @floating_regions << r
        #     @need_convert_floating_regions_coordinates = true
        #   end
        # end
      end

      def convert_ignored_regions_coordinates
        return unless @need_convert_ignored_regions_coordinates
        self.ignored_regions = @ignored_regions.map do |r|
          puts "***1 #{r.inspect}"
          puts "***2 #{selector_regions}"
          puts "***3 #{target.regions}"
          puts "***4 #{selector_regions[target.regions[r]]}"
          region = selector_regions[target.regions[r]]
          Applitools::Region.new(region['x'], region['y'], region['width'], region['height']).to_hash
        end
        @need_convert_ignored_regions_coordinates = false
      end

      # def convert_floating_regions_coordinates
      #   return unless @need_convert_floating_regions_coordinates
      #   self.floating_regions = @floating_regions.map do |r|
      #     updated_region = app_output.screenshot.convert_region_location(
      #         r,
      #         Applitools::EyesScreenshot::COORDINATE_TYPES[:context_relative],
      #         Applitools::EyesScreenshot::COORDINATE_TYPES[:screenshot_as_is]
      #     )
      #     updated_region.to_hash
      #     Applitools::FloatingRegion.new(
      #         updated_region.left,
      #         updated_region.top,
      #         r.width,
      #         r.height,
      #         r.max_left_offset,
      #         r.max_top_offset,
      #         r.max_right_offset,
      #         r.max_bottom_offset
      #     ).padding(r.current_padding)
      #   end  unless app_output.screenshot.nil?
      #   @need_convert_floating_regions_coordinates = false
      # end

    end
  end
end