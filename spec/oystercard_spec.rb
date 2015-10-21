require 'oystercard'

describe Oystercard do

    subject(:card) { Oystercard.new(20)}
    let(:new_card) { Oystercard.new }
    let(:station) { :station }

  context '#top_up' do
    it 'can top up the balance' do
      expect {card.top_up(1)}.to change{card.balance}.by 1
    end
    it 'fails if more than £90 is added' do
      expect{card.top_up(100)}.to raise_error("The topup limit is £#{Oystercard::LIMIT}")
    end
  end

  context '#touch_in' do
    it 'raises an error when not enough balance' do
      expect{new_card.touch_in(station)}.to raise_error 'Not enough balance for this journey'
    end
    it 'records station' do
      card.touch_in(station)
      expect(card.journey.entry_station).to eq station
    end
    it 'deducts a penalty charge if failed to do' do
      card.touch_in(:entry)
      expect{card.touch_in :entry}.to change {card.balance}.by(-Oystercard::PENALTY_FARE)
    end
    it 'now in_journey' do
      card.touch_in(station)
      expect(card).to be_in_journey
    end
  end

  context '#touch_out' do
    it 'deducts minimum fare' do
      card.touch_in(:entry)
      expect{card.touch_out(station)}.to change{card.balance}.by(-Oystercard::MINIMUM_FARE)
      end
    it 'deducts a penalty charge if failed to do' do
      expect{card.touch_out :exit}.to change {card.balance}.by(-Oystercard::PENALTY_FARE)
    end
    it 'no longer in_journey' do
      card.touch_out(station)
      expect(card).not_to be_in_journey
    end
  end
end
