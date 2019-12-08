require_relative 'test_special_cases_v1'

RSpec.describe 'Special cases' do
  context 'Eyes Selenium SDK - Special Cases', selenium: true do
    include_examples 'Eyes Selenium SDK - Special Cases'
  end

  context 'Eyes Selenium SDK - Special Cases', selenium: true, scroll: true do
    include_examples 'Eyes Selenium SDK - Special Cases'
  end

  context 'Eyes Selenium SDK - Special Cases', visual_grid: true do
    include_examples 'Eyes Selenium SDK - Special Cases'
  end
end