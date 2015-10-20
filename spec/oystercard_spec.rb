require 'oystercard'
describe Oystercard do
  it 'card has balance' do
    expect(subject.balance).to be_truthy
    # expect(subject.balance).to be(0)
  end

  let(:station) {double(:exist? => true)}

  context 'topping up' do

    it 'can top up the balance' do
      expect {subject.top_up(1)}.to change{subject.balance}.by 1
    end

    it 'fails if more than £90 is added' do
      expect{subject.top_up(100)}.to raise_error("The topup limit is £#{Oystercard::LIMIT}")
    end
  end

  context 'making journeys when you have a balance' do

      before(:each) {allow(subject).to receive(:balance).and_return(Oystercard::MINIMUM_FARE)}
      it 'changes the journey status to true when touch_in is invoked' do
        subject.touch_in(station)
        expect(subject.in_journey?).to eq true
      end

      it 'in_journey returns the journey_status' do
        subject.touch_in(station)
        expect(subject.in_journey?).to eq true
      end

      it 'changes the journey status to false when touch_out is invoked' do
        allow(subject.entry_station).to receive(:exist?).and_return false
        subject.touch_out
        expect(subject.in_journey?).to eq false
      end

      it 'records station where touch in is invoked' do
        expect(subject.touch_in(station)).to eq station
      end

      it 'forgets the station when touch out is invoked' do
        subject.touch_out
        expect(subject.entry_station).to eq nil
      end
    end

  context 'spending money' do
    it 'deducts the minimum fare from balance when touch_out is invoked' do
        expect{subject.touch_out}.to change{subject.balance}.by(-Oystercard::MINIMUM_FARE)
      end
  end

  context 'making journeys with a balance of zero' do
    it 'raises an error if the balance is below minimum fare when touching in' do
        expect{subject.touch_in(station)}.to raise_error 'Not enough balance for this journey'
    end
  end
end
