RSpec.shared_examples 'can be disabled' do |method, args|
  it 'checks disabled? before a test' do
    expect(subject).to receive(:disabled?).and_return(true)
    expect(subject).to_not receive(:check_window_base)
    subject.send(method, *args)
  end

  it 'returns false if disabled' do
    allow(subject).to receive(:disabled?).and_return(true)
    expect(subject).to_not receive(:check_window_base)
    expect(subject.send(method, *args)).to be false
  end
end
