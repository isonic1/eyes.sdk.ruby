Then(/^set OS$/) do
  sdk_version = perform_action('android_sdk_version')
  if sdk_version['success']
    Applitools::Calabash::EyesSettings.instance.eyes.host_os = "Android (SDK version #{sdk_version['message']})"
  end
end

Then(/^set device pixel ratio$/) do
  display_info = `#{default_device.adb_command} shell dumpsys display`
  # size_match = /deviceWidth=(?<width>\d+), deviceHeight=(?<height>\d+)/.match(display_info)
  density_match = /DisplayDeviceInfo.*density (?<density>\d+)/.match(display_info)
  Applitools::Calabash::EyesSettings.instance.eyes.device_pixel_ratio = density_match[:density].to_i
end

Then(/^set device size$/) do
  result = /mDefaultViewport=.*deviceWidth=(?<width>\d+).*deviceHeight=(?<height>\d+).*\n/.match(
    `#{default_device.adb_command} shell dumpsys display mDefaultViewport`
  )
  step %(eyes viewport size is "#{result[:width].to_i}x#{result[:height].to_i}")
end
