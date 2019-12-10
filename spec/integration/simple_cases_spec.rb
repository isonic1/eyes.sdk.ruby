# frozen_string_literal: true
require_relative 'test_simple_cases_v1'

RSpec.describe 'Simple test cases' do
  context 'Eyes Selenium SDK - Simple Test Cases', selenium: true do
    include_examples 'Eyes Selenium SDK - Simple Test Cases'
  end

  context 'Eyes Selenium SDK - Simple Test Cases', selenium: true, scroll: true do
    include_examples 'Eyes Selenium SDK - Simple Test Cases'
  end

  context 'Eyes Selenium SDK - Simple Test Cases', visual_grid: true do
    include_examples 'Eyes Selenium SDK - Simple Test Cases'
  end
end
