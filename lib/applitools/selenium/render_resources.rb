module Applitools
  module Selenium
    class RenderResources < Hash
      def []=(key, value)
        raise Applitools::EyesIllegalArgument, "Expected key to be an instance of URI (but got #{key.class})" unless
            key.is_a? URI
        raise Applitools::EyesIllegalArgument, "Expected key to be an instance of Applitools::Selenium::VGResource" \
            " (but got #{value.class})" unless value.is_a? Applitools::Selenium::VGResource
        return super
      end
    end
  end
end