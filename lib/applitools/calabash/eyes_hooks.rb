if respond_to? :Before
  Before('@eyes') do |scenario|
    eyes_settings = Applitools::Calabash::EyesSettings.instance

    step %(eyes API key "#{ENV['APPLITOOLS_API_KEY']}") unless eyes_settings.applitools_api_key

    step %(eyes application name is "#{scenario.feature.name}")

    step %(eyes test name is "#{scenario.name}")

    step %(eyes tag is "")

    step %(set it up) if eyes_settings.needs_setting_up

    step %(open eyes)
  end

  Before('@eyes') do |_scenario|
    Applitools::Calabash::EyesSettings.instance.eyes.add_context(self)
  end
end

if respond_to? :After
  After('@eyes', '@close') do |_scenario|
    step %(terminate eyes session)
  end

  After('@eyes') do |_scenario|
    eyes = Applitools::Calabash::EyesSettings.instance.eyes
    Applitools::Calabash::EyesSettings.instance.eyes.remove_context if eyes && eyes.open?
  end
end

# at_exit do
#
# end
