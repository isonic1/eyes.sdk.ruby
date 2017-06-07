require 'spec_helper'

RSpec.describe Applitools::Images::Eyes do
  let(:image) { ChunkyPNG::Image.new(5, 5) }
  let(:target) { Applitools::Images::Target.any(image) }
  before(:each) { subject.default_match_settings[:match_level] = 'TEST' }
  describe ':check_image' do
    it 'passes match_level to base' do
      expect(subject).to receive(:check_window_base) do |*opts|
        expect(opts.last.match_level).to eq 'TEST'
      end.and_return(Applitools::MatchResults.new)
      subject.check_image(tag: 'nil', image: image)
    end
  end

  describe ':check_region' do
    it 'passes match_level to base' do
      expect(subject).to receive(:check_window_base) do |*opts|
        expect(opts.last.match_level).to eq 'TEST'
      end.and_return(Applitools::MatchResults.new)
      subject.check_region(tag: 'nil', image: image, region: Applitools::Region::EMPTY)
    end
  end

  context ':check' do
    before do
      subject.api_key = 'API_KEY_FOR_TESTS'
      subject.open(app_name: 'app_name', test_name: 'test_name')
      allow_any_instance_of(Applitools::MatchWindowTask).to receive(:match_window).and_return(Applitools::MatchResults.new)
    end

    it 'performs \':read_target\' for match_data' do
      expect_any_instance_of(Applitools::MatchWindowData).to receive(:read_target)
      subject.check('', target)
    end

    it 'sets default values before \'reading\' target' do
      expect(subject).to receive(:set_default_settings).with(Applitools::MatchWindowData).and_raise Applitools::EyesError
      expect_any_instance_of(Applitools::MatchWindowData).to_not receive(:read_target)
      begin
        subject.check('', target)
      rescue Applitools::EyesError
      end
    end
  end

  context ':check_single' do
    before do
      subject.api_key = 'API_KEY_FOR_TESTS'
      subject.open(app_name: 'app_name', test_name: 'test_name')
      allow_any_instance_of(Applitools::MatchSingleTask).to receive(:match_window).and_return(Applitools::TestResults.new)
    end

    it 'performs \':read_target\' for match_data' do
      expect_any_instance_of(Applitools::MatchWindowData).to receive(:read_target)
      subject.check_single('', target)
    end

    it 'sets default values before \'reading\' target' do
      expect(subject).to receive(:set_default_settings).with(Applitools::MatchWindowData).and_raise Applitools::EyesError
      expect_any_instance_of(Applitools::MatchWindowData).to_not receive(:read_target)
      begin
        subject.check_single('', target)
      rescue Applitools::EyesError
      end
    end
  end

end
