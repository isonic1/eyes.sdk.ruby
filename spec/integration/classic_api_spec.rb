require_relative 'test_classic_api_v1'
RSpec.describe 'Classic API' do
  context 'Eyes Selenium SDK - Classic API', selenium: true do
    include_examples 'Classic API'
  end

  context 'Eyes Selenium SDK - Classic API', selenium: true, scroll: true do
    include_examples 'Classic API'
  end

  context 'Eyes Selenium SDK - Classic API', visual_grid: true do
    include_examples 'Classic API'
  end
end