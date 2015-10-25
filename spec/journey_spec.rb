require 'journey'

describe Journey do
  subject(:journey) { described_class.new(entry_station: :entry_station)}
  describe 'a new journey' do
    it 'has an entry station' do
      expect(journey.entry_station).to eq :entry_station
    end
  end

  describe 'complete a journey' do
    it 'registers the exit station' do
      journey.complete(:exit_station)
      expect(journey.exit_station).to eq :exit_station
    end
  end

  describe '#complete?' do
    it 'knows when a journey is complete' do
      journey.complete(:exit_station)
      expect(journey).to be_complete
    end
  end

  describe '#fare' do
    context 'journey complete' do
      it 'returns the minimum fare' do
        journey.complete(:exit_station)
        expect(journey.fare).to eq described_class::MIN_FARE
      end
    end
    context 'returns penalty fare at incomplete journey' do
      it 'when no exit station is given' do
        expect(journey.fare).to eq described_class::PENALTY_FARE
      end
      it 'when no entry station is given' do
        journey = Journey.new(entry_station: nil)
        expect(journey.fare).to eq described_class::PENALTY_FARE
      end
    end
  end
end
