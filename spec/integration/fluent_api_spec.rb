require_relative 'test_fluent_api_v1'
RSpec.describe 'Fluent API' do
  context 'Eyes Selenium SDK - Fluent API', selenium: true do
    include_examples 'Fluent API'
  end

  context 'Eyes Selenium SDK - Fluent API', selenium: true, scroll: true do
    include_examples 'Fluent API'
  end

  context 'Eyes Selenium SDK - Fluent API', visual_grid: true do
    include_examples 'Fluent API'
  end
end