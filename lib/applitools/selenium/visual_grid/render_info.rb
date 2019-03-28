module Applitools
  module Selenium
    class RenderInfo
      include Applitools::Jsonable
      json_fields :width, :height, :sizeMode
      # , :region, :emulationInfo
    end
  end
end