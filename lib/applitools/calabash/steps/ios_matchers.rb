Then /^the whole screen should match a baseline/ do
  step %{create target}
  step %{target should match a baseline}
end

Then /^query element "([^"]*)" and take (\d+)$/ do |query, index|
  @current_element = nil
  @current_element = Applitools::Calabash::Utils.get_ios_element(query, index)
  if (hash = query(query, :hash)[index.to_i]) > 0
    element_query = "* hash:#{hash}"
    element = query(element_query)
    @current_element = Applitools::Calabash::CalabashElement.new(element, element_query)
  else
    element_query = query + " index:#{index}"
    element = query(element_query)
    @current_element = Applitools::Calabash::CalabashElement.new(element, element_query)
  end
end
