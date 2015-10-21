require 'journey'

describe Journey do
  subject(:journey) { Journey.new }
  let(:card) {double(:card)}

  context '#log' do
    it 'is empty by default' do
      expect(journey.history).to be_empty
    end
    it 'logs entry and exit station after a journey' do
      journey.set_entry_station :entry_station
      journey.log :exit_station
      expect(journey.history[0]).to eq(entry_station: :exit_station)
    end
  end

  # context '#fare' do
  #   it 'returns minimum fare' do
  #     expect(journey.fare).to eq described_class::MINIMUM_FARE
  #   end
  #   it 'retuns penalty fare when no entry_station' do
  #
  #   end
  #   it 'retuns penalty fare when no exit_station' do
  #
  #   end
  # end
end
