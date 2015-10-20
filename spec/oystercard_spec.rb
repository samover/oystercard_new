require 'oystercard'
describe Oystercard do
  it 'card has balance' do
    expect(subject.balance).to be_truthy
    # expect(subject.balance).to be(0)
  end


  describe '#top_up' do

    it {is_expected.to respond_to(:top_up).with(1).argument}

    it 'can top up the balance' do
      expect {subject.top_up(1)}.to change{subject.balance}.by 1
    end

    it 'fails if more than £90 is added' do
      expect{subject.top_up(100)}.to raise_error("The topup limit is £#{Oystercard::LIMIT}")
    end

    describe '#deduct' do

      it 'deducts the amount in the argument from the balance' do
        expect{subject.deduct(1)}.to change{subject.balance}.by(-1)
      end

    end

    # it 'adds money' do
    #   expect(subject.top_up(15)).to eq subject.balance
    # end
  end
end
