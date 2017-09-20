Then(/^ignore status bar$/) do
  raise Applitools::EyesError, '@target is not set' unless @target
  step %(query element "view id:'statusBarBackground'")
  @target.ignore @current_element if @current_element
end

Then(/^the whole screen should match a baseline/) do
  step %(create target)
  step %(ignore status bar)
  step %(target should match a baseline)
end

Then(/^query element "([^"]*)" and take (\d+)$/) do |query, index|
  @current_element = nil
  @current_element = Applitools::Calabash::Utils.get_android_element(self, query, index)
end
