Then /^ignore status bar$/ do
  raise Applitools::EyesError, '@target is not set' unless @target
  status_bar = query("view id:'statusBarBackground'").first
  if status_bar
    ignore_region = Applitools::Calabash::Utils.region_from_element(status_bar)
    @target.ignore(ignore_region)
  end
end

Then /^the whole screen should match a baseline/ do
  step %{take eyes screenshot}
  step %{ignore status bar}
  step %{target should match a baseline}
end
