RSpec::Matchers.define :match_region do |expected|
  match do |actual|
    raise Applitools::EyesIllegalArgument, "Expected #{expected} to be a Applitools::Region instance, but got #{expected.class.name}." unless expected.is_a? Applitools::Region
    raise Applitools::EyesIllegalArgument, "Expected #{actual} to be a Applitools::Region instance, but got #{actual.class.name}." unless actual.is_a? Applitools::Region

    expect(actual.x).to eq expected.x
    expect(actual.y).to eq expected.y
    expect(actual.width).to eq expected.width
    expect(actual.height).to eq expected.height
  end
end