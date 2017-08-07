Then /^take eyes screenshot$/ do
  @target = nil
  Applitools::Calabash::Utils.using_screenshot(self) do |screenshot_path|
    @target = Applitools::Calabash::Target.path(screenshot_path, Applitools::Calabash::EyesSettings.instance.eyes.density)
  end
end

Then /^the whole screen should match a baseline/ do
  step %{take eyes screenshot}
  step %{target should match a baseline}
end
