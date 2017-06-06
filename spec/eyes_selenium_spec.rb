require 'spec_helper'
require 'eyes_selenium'

RSpec.describe Applitools::Selenium::Eyes do
  let(:element) { Selenium::WebDriver::Element.new('', nil) }
  let(:target_locator) do
    double.tap do |t|
      allow(t).to receive(:frame)
    end
  end
  let(:original_driver) do
    double(Selenium::WebDriver).tap do |d|
      allow(d).to receive(:driver_for_eyes).and_return(d)
      allow(d).to receive(:execute_script).and_return(width: 0, height: 0)
      allow(d).to receive(:find_element).and_return(element)
      allow(d).to receive(:switch_to).and_return(target_locator)
    end
  end

  before do
    subject.api_key = 'API_KEY_FOR_TESTS'
    subject.open(driver: driver, app_name: 'app_name', test_name: 'test_name')
  end

  let(:driver) { Applitools::Selenium::Driver.new(subject, driver: original_driver) }
  describe ':check_window' do
    it_should_behave_like 'can be disabled', :check_window, []
  end

  describe ':check_region' do
    it_should_behave_like 'can be disabled', :check_region, [[:id, 'id']]
  end

  describe ':check_frame' do
    it_should_behave_like 'can be disabled', :check_frame, [{index: 0}]
  end

  describe ':check_region_in_frame' do
    it_should_behave_like 'can be disabled', :check_region_in_frame, [{index: 0, by: [:id, 'id']}]
  end

  describe ':check' do
    it_should_behave_like 'can be disabled', :check, ['name', Applitools::Selenium::Target.new]
  end
end