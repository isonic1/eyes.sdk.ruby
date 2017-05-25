require 'spec_helper'
RSpec.describe Applitools::Selenium::Target do
  it_behaves_like 'has chain methods',
    fully: nil,
    ignore_caret: [false],
    floating: [Applitools::FloatingRegion.new(0, 0, 0, 0, 0, 0, 0, 0)]

  context 'ignore_caret' do
    it 'sets ignore_caret option' do
      subject.ignore_caret(true)
      expect(subject.options[:ignore_caret]).to be true
    end

    it 'sets default value when called without args' do
      subject.ignore_caret
      expect(subject.options[:ignore_caret]).to be false
    end

    it 'false by default' do
      expect(subject.options[:ignore_caret]).to be false
    end
  end

  context 'region methods' do
    let(:driver) do
      double.tap do |d|
        allow(d).to receive(:find_element)
      end
    end

    context 'floating' do
      before do
        expect(subject.instance_variable_get(:@floating_regions)).to receive(:<<) do |*args|
          expect(args.first).to be_a Proc
          expect { args.first.call(driver) }.to_not raise_error
        end
      end
      it 'accepts :how, :what' do
        allow(Applitools::FloatingRegion).to receive :for_element
        subject.floating(:css, '.class', 10, 10 ,10, 10)
      end
      it 'accepts Applitools::Region' do
        subject.floating(Applitools::Region::EMPTY, 10, 10 ,10, 10)
      end
      it 'accepts Applitools::Selenium::Element' do
        subject.floating(Applitools::Selenium::Element.new(driver, Applitools::Region::EMPTY), 10, 10, 10, 10)
      end
      it 'accepts Applitools::FloatingRegion' do
        subject.floating(Applitools::FloatingRegion.new(0, 0, 0, 0, 0, 0, 0, 0))
      end
    end

    context 'region' do
      before do
        expect(subject.instance_variable_get(:@region_to_check)).to be_a Proc
        expect { subject.instance_variable_get(:@region_to_check).call(driver) }.to_not raise_error
      end
      it 'accepts :how, :what' do
        subject.region(:css, '.class')
      end
      it 'accepts Applitools::Region' do
        subject.region(Applitools::Region::EMPTY)
      end
      it 'accepts Applitools::Selenium::Element' do
        subject.region(Applitools::Selenium::Element.new(driver, Applitools::Region::EMPTY))
      end
    end

    context 'ignore' do
      before do
        expect(subject.instance_variable_get(:@ignored_regions)).to receive(:<<) do |*args|
          expect(args.first).to be_a Proc
          expect { args.first.call(driver) }.to_not raise_error
        end
      end
      it 'accepts :how, :what' do
        subject.ignore(:css, '.class')
      end
      it 'accepts Applitools::Region' do
        subject.ignore(Applitools::Region::EMPTY)
      end
      it 'accepts Applitools::Selenium::Element' do
        subject.ignore(Applitools::Selenium::Element.new(driver, Applitools::Region::EMPTY))
      end
    end
  end
end
