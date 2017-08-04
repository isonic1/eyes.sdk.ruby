Then /^target should match a baseline$/ do
  raise Applitools::EyesError, '@target is not set' unless @target
  raise Applitools::EyesError, '@tag is not set' unless @tag
  expect(@target).to match_baseline(@tag)
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
    @target.region(Applitools::Calabash::CalabashElement.new(element))
  end
end


