if respond_to? :Before
  Before('@eyes') do |scenario|
    eyes_settings = Applitools::Calabash::EyesSettings.instance

    step %{eyes API key "#{ENV['APPLITOOLS_API_KEY']}"} unless eyes_settings.applitools_api_key

    step %{eyes application name is "#{scenario.feature.name}"}

    step %{eyes test name is "#{scenario.name}"} unless eyes_settings.test_name

    step %{eyes tag is ""}

    step %{set it up} if eyes_settings.needs_setting_up
  end
end

if respond_to? :After
  After('@eyes', '@close') do |scenario|
    p 'AFTER'
  end
end
