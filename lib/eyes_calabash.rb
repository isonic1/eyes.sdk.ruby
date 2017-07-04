require 'eyes_images'

module Applitools
  module Calabash
    extend Applitools::RequireUtils

    def self.load_dir
      File.dirname(File.expand_path(__FILE__))
    end
  end
end

Applitools::Calabash.require_dir 'calabash'


