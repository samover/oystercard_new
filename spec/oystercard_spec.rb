require 'oystercard'

describe Oystercard do

    subject(:card) { Oystercard.new(20)}
    let(:new_card) { Oystercard.new }
    let(:station) { :station }

  context 'topping up' do

    it 'can top up the balance' do
      expect {card.top_up(1)}.to change{card.balance}.by 1
    end

    it 'fails if more than £90 is added' do
      expect{card.top_up(100)}.to raise_error("The topup limit is £#{Oystercard::LIMIT}")
    end
  end

  context 'making journeys when you have a balance' do

      it 'changes the journey status to true when touch_in is invoked' do
        card.touch_in(station)
        expect(card).to be_in_journey
      end

      it 'changes the journey status to false when touch_out is invoked' do
        card.touch_out(station)
        expect(card).not_to be_in_journey
      end



      it 'forgets the station when touch out is invoked' do
        card.touch_out(station)
        expect(card.entry_station).to eq nil
      end
    end

  context 'spending money' do
    it 'deducts the minimum fare from balance when touch_out is invoked' do
        card.touch_in(:entry)
        expect{card.touch_out(station)}.to change{card.balance}.by(-Oystercard::MINIMUM_FARE)
      end
  end

  context 'making journeys with a balance of zero' do
    it 'raises an error if the balance is below minimum fare when touching in' do
        expect{new_card.touch_in(station)}.to raise_error 'Not enough balance for this journey'
    end
  end

  context 'logging a journey' do
    it 'log is empty by default' do
      expect(card.journey).to be_empty
    end

    it 'logs entry and exit station after a journey' do
      card.touch_in(:entry)
      card.touch_out(:exit)
      expect(card.journey.first).to include :entry
    end

    context '#touch_in' do
      it 'records station' do
        card.touch_in(station)
        expect(card.entry_station).to eq station
      end

      it 'deducts a penalty charge if failed to do' do
        card.touch_in(:entry)
        expect{card.touch_in :entry}.to change {card.balance}.by(-Oystercard::PENALTY_FARE)
      end
    end

    context '#touch_out' do
      it 'deducts a penalty charge if failed to do' do
        expect{card.touch_out :exit}.to change {card.balance}.by(-Oystercard::PENALTY_FARE)
      end

    end
  end

end
