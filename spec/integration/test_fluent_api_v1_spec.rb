require 'spec_helper'

RSpec.shared_examples 'Fluent API' do
  let(:url_for_test) { 'https://applitools.github.io/demo/TestPages/FramesTestPage/' }

  it('TestCheckRegionWithIgnoreRegion_Fluent') do
    target = Applitools::Selenium::Target.region(:id, 'overflowing-div').ignore(Applitools::Region.new(50, 50, 100,100))
    eyes.check('Fluent - Region with Ignore region', target)
  end

  it('TestCheckRegionBySelectorAfterManualScroll_Fluent') do
    driver.execute_script('window.scrollBy(0,900)')
    target = Applitools::Selenium::Target.region(:id, 'centered')
    eyes.check('Fluent - Region by selector after manual scroll', target)
  end

  it('TestCheckWindow_Fluent') do
    eyes.check('Fluent - Window', Applitools::Selenium::Target.window)
  end

  it('TestCheckWindowWithIgnoreBySelector_Centered_Fluent') do
    eyes.check('Fluent - Window with ignore region by selector centered', Applitools::Selenium::Target.window.ignore(:id, 'centered'))
  end

  it('TestCheckWindowWithIgnoreBySelector_Stretched_Fluent') do
    eyes.check('Fluent - Window with ignore region by selector centered', Applitools::Selenium::Target.window.ignore(:id, 'stretched'))
  end

  it('TestCheckWindowWithFloatingBySelector_Fluent') do
    eyes.check('Fluent - Window with ignore region by selector', Applitools::Selenium::Target.window.floating(:id, 'overflowing-div', 3, 3, 20, 30))
  end

  it('TestCheckRegionByCoordinates_Fluent') do
    eyes.check('Fluent - Region by coordinates', Applitools::Selenium::Target.region(Applitools::Region.new(50, 70,90, 110)))
  end

  it('TestCheckOverflowingRegionByCoordinates_Fluent()') do
    eyes.check('Fluent - Region by overflowing coordinates', Applitools::Selenium::Target.region(Applitools::Region.new(50, 110, 90, 550)))
  end

  # it('estCheckElementWithIgnoreRegionByElementOutsideTheViewport_Fluent') do
  #   element = driver.find_element(:id, 'overflowing-div-image')
  #   eyes.check('Fluent - Region by element', Applitools::Selenium::Target.region(element).ignore(element))
  # end

  it('TestScrollbarsHiddenAndReturned_Fluent') do
    eyes.check('Fluent - Window (Before)', Applitools::Selenium::Target.window.fully)
    eyes.check(
      'Fluent - Inner frame div',
      Applitools::Selenium::Target.frame('frame1').region(:id, 'inner-frame-div').fully
    )
    eyes.check('Fluent - Window (After)', Applitools::Selenium::Target.window.fully)
  end

  it('TestCheckElementFully_Fluent') do
    element = driver.find_element(:id, 'overflowing-div-image')
    eyes.check('Fluent - Region by element - fully', Applitools::Selenium::Target.region(element).fully)
  end

  it('TestSimpleRegion') do
    eyes.check(nil, Applitools::Selenium::Target.region(Applitools::Region.new(50, 50, 100, 100)))
  end
end

RSpec.describe 'Eyes Selenium SDK - Fluent API', selenium: true do
  context do
    include_examples 'Fluent API'
  end

  context 'Scroll', scroll: true do
    include_examples 'Fluent API'
  end
end