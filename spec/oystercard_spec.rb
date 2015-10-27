require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new(balance: 20, journey_log_klass: journey_log_klass) }

  let(:max) { described_class::MAX_BALANCE }
  let(:min) { described_class::MIN_FARE }
  let(:entry_station) { double(:station, name: 'entry_station', zone: 1) }
  let(:exit_station) { double(:station, name: 'exit_station', zone: 2) }
  let(:journey_log_klass) { double(:journey_log_klass, new: journey_log)}
  let (:journey) { double(:journey, entry_station: [entry_station.name, entry_station.zone],
    exit_station: [exit_station.name, exit_station.zone], complete: exit_station) }
  let (:journey_log) { double(:journey_log) }
  describe 'a new card' do
    let(:oystercard) { described_class.new(journey_log_klass: journey_log_klass) }

    it 'has a default balance' do
      expect(oystercard.balance).to eq described_class::DEF_BALANCE
    end
  end

  describe '#topup' do
    it 'adds money to the card' do
      expect{oystercard.topup min}.to change {oystercard.balance}.by(min)
    end
    it 'raises an error when limit exceeded' do
      msg = "Max of #{max} exceeded"
      expect{oystercard.topup max}. to raise_error msg
    end
  end

  describe '#touch_in' do
    it 'raises an error when insufficient balance' do
      oystercard = described_class.new(journey_log_klass: journey_log_klass) 
      allow(oystercard.journey_log).to receive(:journey_in_progress?).and_return(false)
      expect{oystercard.touch_in entry_station}.to raise_error 'Insufficient balance'
    end
    it 'changes status to in_journey' do
      allow(journey_log).to receive(:journey_in_progress?).and_return(false)
      allow(journey_log).to receive(:start_journey).and_return(entry_station)
      oystercard.touch_in entry_station
      allow(journey_log).to receive(:journey_in_progress?).and_return(true)
      expect(oystercard.in_journey?).to eq true
    end
  end

  describe '#touch_out' do
    before do
      allow(journey_log).to receive(:journey_in_progress?).and_return(false)
      allow(journey_log).to receive(:start_journey).and_return(entry_station)     
      allow(journey_log).to receive(:exit_journey).and_return(exit_station)
      allow(journey_log).to receive(:fare).and_return(min)
    end
    it 'deducts fare' do
      oystercard.touch_in entry_station
      expect{oystercard.touch_out exit_station}.to change {oystercard.balance}.by(-min)
    end
    it 'changes status to not in_journey' do
      oystercard.touch_in entry_station
      oystercard.touch_out exit_station
      expect(oystercard.in_journey?).to be false
    end
  end
end
