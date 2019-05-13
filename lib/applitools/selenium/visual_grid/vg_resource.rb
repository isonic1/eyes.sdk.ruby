require 'base64'
require 'digest'
module Applitools
  module Selenium
    class VGResource
      include Applitools::Jsonable
      json_fields :contentType, :hash, :hashFormat
      attr_accessor :url, :content
      alias :content_type :contentType
      alias :content_type= :contentType=

      class << self
        def parse_blob_from_script(blob)
          content = Base64.decode64(blob["value"])
          # puts "#{blob['url']} ===> #{blob['type']}"
          self.new blob["url"], blob["type"], content
        end

        def parse_response(url, response)
          return self.new(url, 'application/empty-response', '') unless response.status == 200
          self.new(url, response.headers['Content-Type'], response.body)
        end
      end

      def initialize(url, content_type, content)
        self.url = URI(url)
        self.content_type = content_type
        self.content = content
        self.hash = Digest::SHA256.hexdigest(content)
        self.hashFormat = 'sha256'
      end

      def stringify
        url.to_s + content_type.to_s + hash
      end
    end
  end
end