require 'capybara/rspec'
require 'oystercard'
require 'journey'

describe 'oystercard' do
  let(:card) { Oystercard.new(20) }
  let(:journey) { Journey.new }

  feature 'I want to see my previous trips' do
    scenario 'after one trip' do
      card.touch_in('entry_station')
      card.touch_out('exit_station')
      expect(card.journey.history.first).to include 'entry_station'
    end
  end

  feature 'deducts a penalty' do
    scenario 'when not exit_station' do
      card.touch_in('entry_station')
      expect{card.touch_in('entry_station')}.to change {card.balance}.by(-Journey::PENALTY_FARE)
    end
    scenario 'when no entry_station' do
      expect{card.touch_out('exit_station')}.to change {card.balance}.by(-Journey::PENALTY_FARE)
    end
  end

end
