Then /^create target$/ do
  @target = nil
  @target = Applitools::Calabash::Target.new
end

Then /^target should match a baseline$/ do
  raise Applitools::EyesError, '@target is not set' unless @target
  raise Applitools::EyesError, '@tag is not set' unless @tag
  expect(@target).to match_baseline(@tag)
end

Then /^the element "([^"]*)" should match a baseline$/ do |query|
  step %{create target}
  step %{query element "#{query}"}
  @target.region(@current_element) if @current_element
  step %{target should match a baseline}
end

Then /^the entire element "([^"]*)" should match a baseline$/ do |query|
  step %{create target}
  step %{query element "#{query}"}
  @target.region(@current_element).fully if @current_element
  step %{target should match a baseline}
end

Then /^query element "([^"]*)"$/ do |query|
  step %{query element "#{query}" and take 0}
end



