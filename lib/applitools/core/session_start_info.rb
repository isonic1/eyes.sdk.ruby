# frozen_string_literal: true

module Applitools
  class SessionStartInfo
    attr_accessor :app_id_or_name, :scenario_id_or_name

    def initialize(options = {})
      @agent_id = options[:agent_id]
      @app_id_or_name = options[:app_id_or_name]
      @ver_id = options[:ver_id]
      @scenario_id_or_name = options[:scenario_id_or_name]
      @batch_info = options[:batch_info]
      @env_name = options[:env_name]
      @environment = options[:environment]
      @default_match_settings = options[:default_match_settings]
      @branch_name = options[:branch_name]
      @parent_branch_name = options[:parent_branch_name]
      @properties = options[:properties]
      @compare_with_parent_branch = options[:compare_with_parent_branch]
    end

    def to_hash
      {
        agent_id: @agent_id,
        app_id_or_name: @app_id_or_name,
        ver_id: @ver_id,
        scenario_id_or_name: @scenario_id_or_name,
        batch_info: @batch_info && @batch_info.to_hash,
        env_name: @env_name,
        environment: @environment.to_hash,
        default_match_settings: @default_match_settings,
        branch_name: @branch_name,
        parent_branch_name: @parent_branch_name,
        compare_with_parent_branch: @compare_with_parent_branch,
        properties: @properties
      }
    end
  end
end
