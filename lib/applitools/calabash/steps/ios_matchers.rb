Then /^the whole screen should match a baseline/ do
  step %{take eyes screenshot}
  step %{target should match a baseline}
end
