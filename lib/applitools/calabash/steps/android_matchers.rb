Then /^take eyes screenshot$/ do
  @target = nil
  Applitools::Calabash::Utils.using_screenshot(self) do |screenshot_path|
    @target = Applitools::Calabash::Target.path(screenshot_path)
  end
end

Then /^ignore status bar$/ do
  raise Applitools::EyesError, '@target is not set' unless @target
  status_bar = query("view id:'statusBarBackground'").first
  @target.ignore Applitools::Calabash::CalabashElement.new(status_bar) if status_bar
end

Then /^the whole screen should match a baseline/ do
  step %{take eyes screenshot}
  step %{ignore status bar}
  step %{target should match a baseline}
end
