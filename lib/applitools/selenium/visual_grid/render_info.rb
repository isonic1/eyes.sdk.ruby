module Applitools
  module Selenium
    class RenderInfo
      include Applitools::Jsonable
      json_fields :width, :height, :sizeMode, :emulationInfo
      # , :region, :emulationInfo

      def json_data
        result = {
          width: width,
          height: height,
          sizeMode: size_mode
        }
        result['emulationInfo'] = json_value(emulation_info) if emulation_info
        result
      end
    end
  end
end