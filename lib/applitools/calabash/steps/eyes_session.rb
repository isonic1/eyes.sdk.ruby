Then /^open eyes$/ do
  eyes_settings = Applitools::Calabash::EyesSettings.instance
  eyes_settings.eyes ||= Applitools::Calabash::Eyes.new.tap do |eyes|
    eyes.api_key = eyes_settings.applitools_api_key
    log_file_path = File.join(eyes_settings.log_prefix, eyes_settings.log_file)
    eyes.log_handler = Logger.new(File.new(log_file_path, 'w+'))
  end

  unless eyes_settings.eyes.open?
    step %{set OS}
    step %{set density}
    step %{set device size}
    eyes_settings.eyes.open eyes_settings.options_for_open
  end
end

When(/^I close eyes session$/) do
  @test_result = Applitools::Calabash::EyesSettings.instance.eyes.close(false)
end

Then(/^test result should be positive$/) do
  raise Applitools::EyesError, 'Test result are not present!' unless @test_result
  expect(@test_result).to be_success
end

Then(/^applitools link should be reported$/) do
  puts @test_result
end

Then /^terminate eyes session$/ do
  step %{I close eyes session}
  step %{test result should be positive}
  step %{applitools link should be reported}
  @test_results = nil
end

if defined?(Calabash::Android)
  Then /^set OS$/ do
    sdk_version = perform_action('android_sdk_version')
    if sdk_version['success']
      Applitools::Calabash::EyesSettings.instance.eyes.host_os = "Android (SDK version #{sdk_version['message']})"
    end
  end

  Then /^set density$/ do
    result = /DisplayDeviceInfo.*density (?<density>\d+)/.match(
      `#{default_device.adb_command} shell dumpsys display`
    )
    Applitools::Calabash::EyesSettings.instance.eyes.density = result[:density]
  end

  Then /^set device size$/ do
    result = /mDefaultViewport=.*deviceWidth=(?<width>\d+).*deviceHeight=(?<height>\d+).*\n/.match(
      `#{default_device.adb_command} shell dumpsys display mDefaultViewport`
    )
    step %{eyes viewport size is "#{result[:width].to_i}x#{result[:height].to_i}"}
  end
elsif defined?(Calabash::Cucumber)
  Then /^set OS$/ do
    Applitools::Calabash::EyesSettings.instance.eyes.host_os = "iOS(#{default_device.ios_version})"
  end

  Then /^set density$/ do
    dimensions = default_device.screen_dimensions
    Applitools::Calabash::EyesSettings.instance.eyes.density = dimensions[:scale] #:native_scale?
  end

  Then /^set device size$/ do
    dimensions = default_device.screen_dimensions
    step %{eyes viewport size is "#{dimensions[:width].to_i}x#{dimensions[:height].to_i}"}
  end
end
