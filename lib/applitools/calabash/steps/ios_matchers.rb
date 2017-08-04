# Then /^take eyes screenshot$/ do
#   @target = nil
#   Applitools::Calabash::Utils.using_screenshot(self) do |screenshot_path|
#     @target = Applitools::Images::Target.path(screenshot_path)
#   end
# end

Then /^the whole screen should match a baseline/ do
  step %{take eyes screenshot}
  step %{target should match a baseline}
end
