require 'applitools/core/rectangle_size'
require 'applitools/core/session_types'
require 'applitools/core/batch_info'
require 'applitools/connectivity/proxy'

module Applitools
  class EyesBaseConfiguration < AbstractConfiguration
    DEFAULT_CONFIG = {
      branch_name: ENV['APPLITOOLS_BRANCH'] || '',
      parent_branch_name: ENV['APPLITOOLS_PARENT_BRANCH'] || '',
      baseline_branch_name: ENV['APPLITOOLS_BASELINE_BRANCH'] || '',
      save_diffs: false,
      server_url: 'https://eyessdk.applitools.com',
      api_key: ENV['APPLITOOLS_API_KEY'] || ''
    }.freeze

    class << self
      def default_config
        DEFAULT_CONFIG
      end
    end

    def initialize
      super
      # self.batch_info = Applitools::BatchInfo.new
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

    def to_s
      config_keys.map do |k|
        "#{k} = #{send(k)}"
      end.join("\n")
    end

    def valid?
      validation_errors.clear

      validation_errors[:app_name] = ':app_name is required' unless app_name
      validation_errors[:test_name] = ':test_name is required' unless test_name

      validation_errors[:app_name] = ':app_name is required' if app_name && app_name.empty?
      validation_errors[:test_name] = ':test_name is required' if test_name && test_name.empty?
      # validation_errors[:viewport_size] = ':viewport_size is required' if viewport_size.square.zero?
      return true if validation_errors.keys.size.zero?
      false
    end

    def batch
      if batch_info.nil?
        Applitools::EyesLogger.info 'No batch set'
        self.batch_info = BatchInfo.new
      end
      batch_info
    end

    def batch=(value)
      self.batch_info = value
    end

    methods_to_delegate.push :batch
    methods_to_delegate.push :batch=

    string_field :branch_name
    string_field :parent_branch_name
    string_field :baseline_branch_name
    string_field :agent_id
    string_field :environment_name
    boolean_field :save_diffs
    enum_field :session_type, Applitools::SessionTypes.enum_values
    object_field :batch_info, Applitools::BatchInfo
    string_field :baseline_env_name
    string_field :app_name
    string_field :test_name
    object_field :viewport_size, Applitools::RectangleSize
    string_field :api_key
    string_field :server_url
    string_field :host_os
    string_field :host_app
    object_field :proxy, Applitools::Connectivity::Proxy
    string_field :match_level

    methods_to_delegate.delete(:batch_info)
    methods_to_delegate.delete(:batch_info=)

    def short_description
      "#{test_name} of #{app_name}"
    end

    def set_proxy(uri, user = nil, password = nil)
      self.proxy = Applitools::Connectivity::Proxy.new(uri, user, password)
    end

    methods_to_delegate.push(:set_proxy)
  end
end