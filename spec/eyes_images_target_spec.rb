require 'spec_helper'

RSpec.shared_examples 'returns itself' do |methods|
  methods.each do |m|
    it ":#{m} returns itself" do
      expect(subject.send(m)).to be_a described_class
    end
  end
end

RSpec.describe Applitools::Images::Target do
  describe 'class' do
    it_should_behave_like 'responds to class method',
      [
        :path,
        :blob,
        :image,
        :screenshot,
        :any
      ]

    describe ':path' do
      it 'raises error for wrong path' do
        expect { described_class.path('spec/fixtures/does_not_exist.png') }.to raise_error Applitools::EyesIllegalArgument
      end
      it 'creates a ChunlyPNG::Image and Applitools::Screenshot' do
        expect(ChunkyPNG::Image).to receive(:from_file).with(String).and_return(ChunkyPNG::Image.new(5,5))
        expect(Applitools::Screenshot).to receive(:new).with(ChunkyPNG::Image).and_return(Applitools::Screenshot.from_image(ChunkyPNG::Image.new(5,5)))
        described_class.path('spec/fixtures/pic.png')
      end
      it 'creates a new Eyes::Images::Target instance' do
        expect(described_class).to receive(:new).with(Applitools::Screenshot)
        described_class.path('spec/fixtures/pic.png')
      end

      it 'returns Applitools::Images::Target instance' do
        expect(
            described_class.path('spec/fixtures/pic.png')
        ).to be_a described_class
      end
    end

    describe ':blob' do
      it 'requires an argument' do
        expect { described_class.blob(nil) }.to raise_error Applitools::EyesError
      end
      it 'requires a datastream' do
        expect { described_class.blob('invalid string') }.to raise_error ChunkyPNG::SignatureMismatch
      end
      it 'creates a new Eyes::Images::Target instance' do
        expect(described_class).to receive(:new).with(Applitools::Screenshot)
        described_class.blob(ChunkyPNG::Image.new(5,5).to_datastream.to_blob)
      end
      it 'returns Applitools::Images::Target instance' do
        expect(
          described_class.blob(ChunkyPNG::Image.new(5,5).to_datastream.to_blob)
        ).to be_a described_class
      end
    end

    describe ':image' do
      it 'requires an argument' do
        expect { described_class.blob(nil) }.to raise_error Applitools::EyesError
      end

      it 'creates a new Eyes::Images::Target instance' do
        expect(described_class).to receive(:new).with(Applitools::Screenshot)
        described_class.image(ChunkyPNG::Image.new(5,5))
      end

      it 'returns Applitools::Images::Target instance' do
        expect(
            described_class.image(ChunkyPNG::Image.new(5,5))
        ).to be_a described_class
      end
    end

    describe ':screenshot' do
      it 'requires an argument' do
        expect { described_class.blob(nil) }.to raise_error Applitools::EyesError
      end

      it 'creates a new Eyes::Images::Target instance' do
        expect(described_class).to receive(:new).with(Applitools::Screenshot)
        described_class.screenshot(Applitools::Screenshot.from_image(ChunkyPNG::Image.new(5,5)))
      end

      it 'returns Applitools::Images::Target instance' do
        expect(
            described_class.screenshot(Applitools::Screenshot.from_image(ChunkyPNG::Image.new(5,5)))
        ).to be_a described_class
      end
    end
  end

  describe 'instance methods' do
    let(:subject) do
      described_class.image(ChunkyPNG::Image.new(5,5))
    end
    it_should_behave_like 'responds to method',
      [
        :region,
        :trim,
        :ignore,
        :image,
        :options
      ]
    it_should_behave_like 'returns itself',
      [
        :region,
        :trim,
        :ignore
      ]

  end
end
