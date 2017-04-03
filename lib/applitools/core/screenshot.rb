module Applitools
  class Screenshot < Delegator
    extend Forwardable
    def_delegators :header, :width, :height

    class << self
      def from_region(region)
        new ::ChunkyPNG::Image.new(region.width, region.height).to_blob
      end
    end

    def initialize(image)
      @datastream = ::ChunkyPNG::Datastream.from_string image
    end

    def update!(image)
      Applitools::ArgumentGuard.not_nil(image, 'image')
      Applitools::ArgumentGuard.is_a?(image, 'image', ::ChunkyPNG::Image)
      @datastream = image.to_datastream
      self
    end

    def to_blob
      @datastream.to_blob
    end

    def __getobj__
      restore
    end

    alias image __getobj__

    def header
      @datastream.header_chunk
    end

    def __setobj__(obj)
      @datastream = obj.to_datastream
      self
    end

    def method_missing(method, *args, &block)
      if method =~ /^.+!$/
        __setobj__ super
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      super
    end

    def restore
      ::ChunkyPNG::Image.from_datastream @datastream
    end
  end
end
