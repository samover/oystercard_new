require 'journey_log'

describe JourneyLog do

  let(:journey_klass) { double(:journey_klass) }
  let(:journey) {double(:journey, exit_station: entry_station,
    end_journey: exit_station)}
  let(:entry_station) { double(:station) }
  let(:exit_station)  { double(:station) }

  subject(:journey_log) {described_class.new(journey_klass: journey_klass)}

  describe "#start_journey" do
    before do
      allow(journey_klass).to receive(:new).with(entry_station).and_return(journey)
    end
    it "stores a journey" do
      journey_log.start_journey(entry_station)
      expect(journey_log.journeys).to include(journey)
    end
  end

  describe '#exit_journey' do
    before do
      allow(journey_klass).to receive(:new).with(entry_station).and_return(journey)
      allow(journey).to receive(:complete).with(exit_station)
    end

    it 'adds a exit station to the current journey' do
      journey_log.start_journey entry_station
      journey_log.exit_journey exit_station
      expect(journey_log.journeys).to include journey
    end
  end
end
