# frozen_string_literal: true

require 'rspec'
require 'capybara/rspec'
require_relative '../lib/eyes_selenium'
require 'applitools/capybara'

require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Applitools::MOCK_ENTIRE_SIZE = Applitools::RectangleSize.new(300, 300)

Applitools.register_capybara_driver :browser => :chrome

RSpec.describe 'Layout Check frame and element example', :type => :feature, :js => true do
  let(:eyes) do
    Applitools::Selenium::Eyes.new.tap do |eyes|
      eyes.api_key = ENV['APPLITOOLS_API_KEY']
      eyes.force_full_page_screenshot = true
      eyes.log_handler = Logger.new(STDOUT)
      eyes.stitch_mode = :scroll
      eyes.match_level = Applitools::MATCH_LEVEL[:layout]
      # eyes.explicit_entire_size = Applitools::RectangleSize.new(800, 918)
      # eyes.proxy = Applitools::Connectivity::Proxy.new 'http://localhost:9999'
    end
  end

  it 'Eyes test' do
    eyes.open driver: page, app_name: 'Ruby SDK', test_name: 'Applitools frame and element example',
      viewport_size: { width: 800, height: 600 }
    visit 'https://astappev.github.io/test-html-pages/'
    eyes.check_window 'Whole page'
    eyes.check_region :id, 'overflowing-div', tag: 'Overflowed region', stitch_content: true
    eyes.check_frame name_or_id: 'frame1'
    eyes.check_region_in_frame name_or_id: 'frame1', by: [:id, 'inner-frame-div'],
      tag: 'Inner frame div', stitch_content: true
    eyes.check_region :id, 'overflowing-div-image', tag: 'minions', stitch_content: true
    eyes.close true
  end
end
