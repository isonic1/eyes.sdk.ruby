require 'applitools/core/rectangle_size'
require 'applitools/core/concerns/session_types'
require 'applitools/core/batch_info'

module Applitools
  class EyesBaseConfiguration < AbstractConfiguration
    DEFAULT_CONFIG = {
      branch_name: ENV['APPLITOOLS_BRANCH'] || '',
      parent_branch_name: ENV['APPLITOOLS_PARENT_BRANCH'] || '',
      baseline_branch_name: ENV['APPLITOOLS_BASELINE_BRANCH'] || '',
      save_diffs: false
    }.freeze

    class << self
      def default_config
        DEFAULT_CONFIG
      end
    end

    def merge(other_config)
      return if self.object_id == other_config.object_id
      (config_keys + other_config. config_keys).uniq do |k|
        merge_key(other_config, k)
      end
    end

    def merge_key(other_config, key)
      return unless other_config.send("defined_#{key}?")
      return unless self.respond_to? "#{key}="
      self.send("#{key}=", other_config.send(key))
    end

    def config_keys
      config_hash.keys
    end

    def valid?
      validation_errors.clear
      validation_errors[:app_name] = ':app_name is required' if app_name.empty?
      validation_errors[:test_name] = ':test_name is required' if test_name.empty?
      validation_errors[:viewport_size] = ':viewport_size is required' if viewport_size.square.zero?
      return true if validation_errors.keys.size.zero?
      false
    end

    string_field :branch_name
    string_field :parent_branch_name
    string_field :baseline_branch_name
    string_field :agent_id
    string_field :environment_name
    boolean_field :save_diffs
    enum_field :session_type, Applitools::Concerns::SessionTypes.enum_values
    object_field :batch_info, Applitools::BatchInfo
    string_field :baseline_env_name
    string_field :app_name
    string_field :test_name
    object_field :viewport_size, Applitools::RectangleSize
  end
end