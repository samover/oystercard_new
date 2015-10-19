require 'oystercard'
describe Oystercard do
  it 'card has balance' do
    expect(subject.balance).to be_truthy
    # expect(subject.balance).to be(0)
  end
end
