require 'spec_helper'

RSpec.describe 'TestClassicApi', selenium: true do
  let(:url_for_test) { 'https://applitools.github.io/demo/TestPages/FramesTestPage/' }

  it('TestCheckWindow') { eyes.check_window('Window') }
end
