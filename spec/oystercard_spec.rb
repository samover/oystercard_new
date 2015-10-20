require 'oystercard'
describe Oystercard do
  it 'card has balance' do
    expect(subject.balance).to be_truthy
    # expect(subject.balance).to be(0)
  end


  context 'topping up' do

    it 'can top up the balance' do
      expect {subject.top_up(1)}.to change{subject.balance}.by 1
    end

    it 'fails if more than £90 is added' do
      expect{subject.top_up(100)}.to raise_error("The topup limit is £#{Oystercard::LIMIT}")
    end
  end

  context 'making journeys' do

      it 'deducts the amount in the argument from the balance' do
        expect{subject.deduct(1)}.to change{subject.balance}.by(-1)
      end

      it 'changes the journey status to true when touch_in is invoked' do
        expect(subject.touch_in).to eq true
      end

      it 'changes the journey status to false when touch_out is invoked' do
        expect(subject.touch_out).to eq false
      end

      it 'in_journey returns the journey_status' do
        subject.touch_in
        expect(subject.in_journey?).to eq true
      end
  end
end
