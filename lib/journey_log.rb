class JourneyLog
  attr_reader :journey_klass, :journeys, :journey

  def initialize(journey_klass: Journey)
    @journey_klass = journey_klass
    @journeys = []
  end

  def start_journey(entry_station)
    @journey = journey_klass.new(entry_station)
    journeys << journey
  end

  def exit_journey(exit_station)
    journey.complete exit_station
  end
end
