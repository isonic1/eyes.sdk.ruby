require 'spec_helper'

RSpec.describe Applitools::MatchWindowData do
  describe ':default_data' do
    let(:default_data) { described_class.default_data }
    subject { default_data }
    it 'is a hash' do
      expect(subject).to be_a Hash
    end

    it 'has required keys' do
      expect(subject.keys).to contain_exactly(
        'AppOutput',
        'Id',
        'IgnoreMismatch',
        'MismatchWait',
        'Options',
        'Tag',
        'UserInputs'
      )
    end

    it 'default values' do
      expect(subject['IgnoreMismatch']).to eq false
      expect(subject['MismatchWait']).to be_zero
    end

    describe '[\'AppOutput\']' do
      subject { default_data['AppOutput'] }
      it 'has required keys' do
        expect(subject).to be_a Hash
        expect(subject.keys).to contain_exactly(
          'Elapsed',
          'IsPrimary',
          'Screenshot64',
          'ScreenshotUrl',
          'Title'
        )
      end

      it 'has default values' do
        expect(subject['Elapsed']).to be_zero
        expect(subject['IsPrimary']).to eq false
      end
    end

    describe '[\'options\']' do
      subject { default_data['Options'] }
      it 'has required keys' do
        expect(subject).to be_a Hash
        expect(subject.keys).to contain_exactly(
          'Name',
          'UserInputs',
          'ImageMatchSettings',
          'IgnoreExpectedOutputSettings',
          'ForceMatch',
          'ForceMismatch',
          'IgnoreMatch',
          'IgnoreMismatch',
          'Trim'
        )
      end

      it 'has default values' do
        expect(subject['UserInputs']).to be_a Array
        expect(subject['UserInputs']).to be_empty

        expect(subject['IgnoreExpectedOutputSettings']).to eq false
        expect(subject['ForceMatch']).to eq false
        expect(subject['ForceMismatch']).to eq false
        expect(subject['IgnoreMatch']).to eq false
        expect(subject['IgnoreMismatch']).to eq false
      end

      describe '[\'Trim\']' do
        subject { default_data['Options']['Trim'] }
        it 'has requirede keys' do
          expect(subject).to be_a Hash
          expect(subject.keys).to contain_exactly(
            'Enabled',
            'ForegroundIntensity',
            'MinEdgeLength'
          )
        end

        it 'has default values' do
          expect(subject['Enabled']).to eq false
          expect(subject['ForegroundIntensity']).to be_zero
          expect(subject['MinEdgeLength']).to be_zero
        end
      end

      describe '[\'ImageMatchSettings\']' do
        subject { default_data['Options']['ImageMatchSettings'] }
        it 'has requirede keys' do
          expect(subject).to be_a Hash
          expect(subject.keys).to contain_exactly(
            'Exact',
            'IgnoreCaret',
            'MatchLevel',
            'SplitBottomHeight',
            'SplitTopHeight'
          )
        end

        it 'has default values' do
          expect(subject['IgnoreCaret']).to eq false
          expect(subject['MatchLevel']).to eq 'None'
          expect(subject['SplitBottomHeight']).to be_zero
          expect(subject['SplitTopHeight']).to be_zero
        end

        describe '[\'Exact\']' do
          subject { default_data['Options']['ImageMatchSettings']['Exact'] }
          it 'has requirede keys' do
            expect(subject).to be_a Hash
            expect(subject.keys).to contain_exactly(
              'MatchThreshold',
              'MinDiffHeight',
              'MinDiffIntensity',
              'MinDiffWidth'
            )
          end

          it 'has default values' do
            expect(subject['MatchThreshold']).to be_zero
            expect(subject['MinDiffHeight']).to be_zero
            expect(subject['MinDiffIntensity']).to be_zero
            expect(subject['MinDiffWidth']).to be_zero
          end
        end
      end
    end
  end
end

RSpec.describe Applitools::MatchWindowData do
  let(:app_output) do
    Object.new.tap do |o|
      o.instance_eval do
        define_singleton_method :to_hash do
          :app_output
        end
      end
    end
  end
  subject { Applitools::MatchWindowData.new(:user_inputs, app_output, :tag, :ignore_mismatch) }
  it_should_behave_like 'responds to method', [
    :app_output,
    :app_output=,
    :user_inputs,
    :user_inputs=,
    :tag,
    :tag=,
    :options,
    :options=,
    :ignore_mismatch,
    :ignore_mismatch=,
    :appOutput,
    :userInputs,
    :ignoreMismatch,
    :to_s,
    :to_hash
  ]

  it 'tries convert using to_hash' do
    expect(app_output).to receive(:to_hash)
    subject.to_hash
  end

  it 'returns data as hash' do
    result = subject.to_hash
    expect(result.keys).to include(:userInputs, :appOutput, :tag, :ignoreMismatch)
    expect(result).to a_hash_including(
      :userInputs => :user_inputs,
      :appOutput => :app_output,
      :tag => :tag,
      :ignoreMismatch => :ignore_mismatch
    )
  end
end
