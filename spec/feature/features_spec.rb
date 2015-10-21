require 'capybara/rspec'

describe 'oystercard' do
  let(:card) { Oystercard.new(20) }

  feature 'I want to see my previous trips' do
    scenario 'after one trip' do
      card.touch_in('entry_station')
      card.touch_out('exit_station')
      expect(card.journey.first).to include 'entry_station'
    end
  end
end
