Then /^the whole screen should match a baseline/ do
  step %{create target}
  step %{target should match a baseline}
end
