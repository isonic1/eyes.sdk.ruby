require 'spec_helper'
require 'eyes_selenium'
require 'pry'

RSpec.describe 'Group0', selenium: true do
  context 'Group1' do
    it "example1" do |example|
      driver.get('http://applitools.com')
      eyes.check_window('proba0')
    end
    it "example2"
  end
end