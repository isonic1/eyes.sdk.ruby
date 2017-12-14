if respond_to?(:Around)
  Around('@eyes') do |scenario, block|
    get_scenario_tags(scenario)

    before_feature(scenario) if scenario.feature.children.first == scenario.source.last

    step %(eyes tag is "#{@eyes_current_tags[:tag] || scenario.name}")

    Applitools::Calabash::EyesSettings.instance.eyes.add_context(self)

    block.call

    eyes = Applitools::Calabash::EyesSettings.instance.eyes
    Applitools::Calabash::EyesSettings.instance.eyes.remove_context if eyes && eyes.open?

    after_feature(scenario) if scenario.feature.children.last == scenario.source.last
  end
end

def before_feature(scenario)
  eyes_settings = Applitools::Calabash::EyesSettings.instance

  step %(eyes API key "#{@eyes_current_tags[:api_key] || ENV['APPLITOOLS_API_KEY']}") unless
    eyes_settings.applitools_api_key

  step %(eyes application name is "#{@eyes_current_tags[:app_name]}")

  step %(eyes test name is "#{@eyes_current_tags[:test_name] || scenario.feature.name}")

  step %(set it up) if eyes_settings.needs_setting_up

  step %(open eyes)
end

def after_feature(_scenario)
  step %(terminate eyes session)
end

def get_scenario_tags(scenario)
  @eyes_current_tags ||= {}
  eyes_tag_name_regexp = /@eyes_(?<tag_name>[a-z,A-Z, \_]+) \"(?<value>.*)\"/
  scenario.tags.each do |t|
    match_data = t.name.match eyes_tag_name_regexp
    @eyes_current_tags[match_data[:tag_name].to_sym] = match_data[:value] if match_data
  end
  raise "Application name is not set! Please use tag '@eyes_application_name = \"Application Name\"'" unless
    @eyes_current_tags[:app_name]
end
