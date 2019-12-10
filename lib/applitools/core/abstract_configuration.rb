# frozen_string_literal: true

require 'applitools/core/eyes_configuration_dsl'

module Applitools
  class AbstractConfiguration
    attr_reader :config_hash
    attr_accessor :validation_errors
    extend Applitools::EyesConfigurationDSL

    def initialize
      @config_hash = {}
      self.validation_errors = {}
      default_config = self.class.default_config
      default_config.keys.each do |k|
        send "#{k}=", default_config[k]
      end
    end

    def deep_clone
      new_config = self.class.new
      config_keys.each do |k|
        new_config.send(
          "#{k}=", case value = send(k)
                   when Symbol, FalseClass, TrueClass, Integer, Float
                     value
                   else
                     value.clone
                   end
        )
      end
      new_config
    end

    alias deep_dup deep_clone
  end
end
