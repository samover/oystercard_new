require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new(balance: 20, journey_klass: journey_klass) }
  let(:max) { described_class::MAX_BALANCE }
  let(:min) { described_class::MIN_FARE }
  let(:entry_station) { double(:station, name: 'entry_station', zone: 1) }
  let(:exit_station) { double(:station, name: 'exit_station', zone: 2) }
  let(:journey_klass) { double(:journey_klass)}
  let (:journey) { double(:journey, entry_station: [entry_station.name, entry_station.zone],
    exit_station: [exit_station.name, exit_station.zone], complete: exit_station) }

  describe 'a new card' do
    let(:oystercard) { described_class.new(journey_klass: journey_klass) }
    context '#balance' do
      it 'has a default balance' do
        expect(oystercard.balance).to eq described_class::DEF_BALANCE
      end
    end
    context '#journeys' do
      it 'has none logged' do
        expect(oystercard.journeys).to be_empty
      end
    end
  end

  describe '#topup' do
    it 'adds money to the card' do
      expect{oystercard.topup min}.to change {oystercard.balance}.by(min)
    end
    context 'limit exceeded' do
      it 'raises an error' do
        msg = "Max of #{max} exceeded"
        expect{oystercard.topup max}. to raise_error msg
      end
    end
  end

  describe '#touch_in' do
    before do
      allow(journey_klass).to receive(:new).with(entry_station: entry_station).and_return(journey)
    end
    context 'insufficient balance' do
      it 'raises an error' do
        oystercard = Oystercard.new
        expect{oystercard.touch_in entry_station}.to raise_error 'Insufficient balance'
      end
    end
    it 'changes status to in_journey' do
      allow(journey).to receive(:complete?).and_return(false)
      oystercard.touch_in entry_station
      expect(oystercard.in_journey?).to eq true
    end
  end

  describe '#touch_out' do
    before do
      allow(journey_klass).to receive(:new).with(entry_station: entry_station).and_return(journey)
      allow(journey).to receive(:fare).and_return(min)
      allow(journey).to receive(:complete?).and_return(false)
    end
    it 'deducts fare' do
      oystercard.touch_in entry_station
      expect{oystercard.touch_out exit_station}.to change {oystercard.balance}.by(-min)
    end
    it 'changes status to not in_journey' do
      oystercard.touch_in entry_station
      oystercard.touch_out exit_station
      allow(journey).to receive(:complete?).and_return(true)
      expect(oystercard.in_journey?).to be false
    end
    it 'logs a journey' do
      oystercard.touch_in entry_station
      oystercard.touch_out exit_station
      expect(oystercard.journeys).to include journey
    end
  end
end
