module Applitools::Selenium
  class RegionProvider
    #он нам нужен в селениум?
    attr_reader :region, :coordinate_type
    def initialize(region, coordinate_type)
      @region = region
      @coordinate_type = coordinate_type
    end
  end
end