Then /^take eyes screenshot$/ do
  @target = nil
  Applitools::Calabash::Utils.using_screenshot(self) do |screenshot_path|
    @target = Applitools::Images::Target.path(screenshot_path)
  end
end

Then /^ignore status bar$/ do
  raise Applitools::EyesError, '@target is not set' unless @target
  status_bar = query("view id:'statusBarBackground'").first
  if status_bar
    ignore_region = Applitools::Calabash::Utils.region_from_element(status_bar)
    @target.ignore(ignore_region)
  end
end

Then /^target should match a baseline$/ do
  raise Applitools::EyesError, '@target is not set' unless @target
  raise Applitools::EyesError, '@tag is not set' unless @tag
  expect(@target).to match_baseline(@tag)
end

Then /^the whole screen should match a baseline/ do
  step %{take eyes screenshot}
  step %{ignore status bar} if defined?(Calabash::Android)
  step %{target should match a baseline}
end

Then /^the element "([^"]*)" should match a baseline$/ do |query|
  step %{query element "#{query}"}
  step %{target should match a baseline}
end

Then /^query element "([^"]*)"$/ do |query|
  step %{query element "#{query}" and take 0}
end

Then /^query element "([^"]*)" and take (\d+)$/ do |query, index|
  if element = query(query)[index.to_i]
    step %{take eyes screenshot}
    @target.region(Applitools::Calabash::Utils.region_from_element(element))
  end
end


