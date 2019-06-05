require 'rspec'
require 'spec_helper'

RSpec.describe 'Config Object fields' do
  context 'Match Level' do
    let(:eyes) { Applitools::Selenium::Eyes.new }
    let(:session_start_info) { eyes.send(:session_start_info) }
    let(:match_level) { session_start_info['start_info']['defaultMatchSettings']['matchLevel'] }
    let(:session_info) { Applitools::Session.new('id', 'url', true) }
    let(:driver) { Applitools::Selenium::Driver.new(eyes, {}) }
    let(:selenium_driver) { double }
    before do
      allow(selenium_driver).to receive(:driver_for_eyes).and_return(driver)
      allow(Applitools::Utils::EyesSeleniumUtils).to receive(:extract_viewport_size).and_return Applitools::RectangleSize.new(0,0)
      allow(driver).to receive(:manage)
      allow_any_instance_of(Applitools::Connectivity::ServerConnector).to receive(:start_session) do |*args|
        expect(args.last.to_hash[:default_match_settings][:match_level]).to eq Applitools::MATCH_LEVEL[:layout]
        session_info
      end
    end

    it 'Passes eyes.match_level to session_start_info' do
      eyes.match_level = Applitools::MATCH_LEVEL[:layout]
      eyes.open(driver: selenium_driver, app_name: 'app_name', test_name: 'test_name')
    end

    it 'Passes config.match_level to session_start_info' do
      eyes.configure do |c|
        c.match_level = Applitools::MATCH_LEVEL[:layout]
      end
      eyes.open(driver: selenium_driver, app_name: 'app_name', test_name: 'test_name')
    end

    it 'raises an error if match_level is invalid' do
      expect { eyes.match_level = 'WRONG' }.to raise_error Applitools::EyesError
    end
  end
end

