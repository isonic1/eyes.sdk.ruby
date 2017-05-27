require 'spec_helper'

RSpec.describe Applitools::FloatingRegion do
  subject { Applitools::FloatingRegion.new 0, 0, 0, 0, 0, 0, 0, 0 }
  let(:original_element) do
    instance_double(Selenium::WebDriver::Element).tap do |el|
      allow(el).to receive(:location).and_return Applitools::Location.new(0, 0)
      allow(el).to receive(:size).and_return Applitools::RectangleSize.new(0, 0)
    end
  end
  let(:element) { Applitools::Selenium::Element.new nil, original_element }
  it 'can be created from an element' do
    expect(described_class).to respond_to :for_element
    expect { described_class.for_element(nil, 0, 0, 0, 0) }.to raise_error Applitools::EyesError
    expect { described_class.for_element(element, 0, 0, 0, 0) }.to_not raise_error
  end

  it_should_behave_like 'responds to method', [:to_hash]

  context 'to_hash' do
    it 'conteins necessary keys' do
      expect(subject.to_hash.keys).to contain_exactly(
        'Top', 'Left', 'Width', 'Height', 'MaxLeftOffset', 'MaxRightOffset', 'MaxUpOffset', 'MaxDownOffset'
      )
    end
  end
end
