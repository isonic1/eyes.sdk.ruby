module Applitools
  module Selenium
    class RenderResources < Hash
      class ResourceMissingInCache < EyesError; end
      def []=(key, value)
        raise Applitools::EyesIllegalArgument, "Expected key to be an instance of URI (but got #{key.class}) - #{key}" unless
            key.is_a? URI
        raise Applitools::EyesIllegalArgument, "Expected value to be an instance of Applitools::Selenium::VGResource" \
            " (but got #{value.class}) - #{key}:#{value}" unless value.is_a? Applitools::Selenium::VGResource
        super
      end
    end
  end
end