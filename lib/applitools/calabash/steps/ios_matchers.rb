Then /^the whole screen should match a baseline/ do
  step %{create target}
  step %{target should match a baseline}
end

Then /^query element "([^"]*)" and take (\d+)$/ do |query, index|
  @current_element = nil
  @current_element = Applitools::Calabash::Utils.get_ios_element(self, query, index)
end
