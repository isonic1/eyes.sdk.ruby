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
            @need_convert_ignored_regions_coordinates = true unless @need_convert_ignored_regions_coordinates
            case r
            when Proc
              region, padding_proc = r.call(driver, true)
              # require 'pry'
              # binding.pry
              region = selector_regions[target.regions[region]]
              retrieved_region = Applitools::Region.new(region['x'], region['y'], region['width'], region['height'])
              @ignored_regions << padding_proc.call(retrieved_region) if padding_proc.is_a? Proc
            when Applitools::Region
              @ignored_regions << r
            end
          end
        end

        # # floating regions
        return unless target.respond_to? :floating_regions
        target.floating_regions.each do |r|
          case r
          when Proc
            region, padding_proc = r.call(driver, true)
            region = selector_regions[target.regions[region]]
            retrieved_region = Applitools::Region.new(region['x'], region['y'], region['width'], region['height'])
            floating_region = padding_proc.call(retrieved_region) if padding_proc.is_a? Proc
            raise Applitools::EyesError.new "Wrong floating region: #{region.class}" unless
                floating_region.is_a? Applitools::FloatingRegion
            @floating_regions << floating_region
            @need_convert_floating_regions_coordinates = true
          when Applitools::FloatingRegion
            @floating_regions << r
            @need_convert_floating_regions_coordinates = true
          end
        end
      end

      def convert_ignored_regions_coordinates
        return unless @need_convert_ignored_regions_coordinates
        self.ignored_regions = @ignored_regions.map(&:with_padding).map(&:to_hash)
        @need_convert_ignored_regions_coordinates = false
      end

      def convert_floating_regions_coordinates
        return unless @need_convert_floating_regions_coordinates
        self.floating_regions = @floating_regions
        @need_convert_floating_regions_coordinates = false
      end

    end
  end
end