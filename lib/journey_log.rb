class JourneyLog
  attr_reader :journey_klass, :journey, :journeys

  def initialize(journey_klass: Journey)
    @journey_klass = journey_klass
    @journeys = []
  end

  def start_journey(entry_station)
    current_journey(entry_station)
    journeys << journey
  end

  def exit_journey(exit_station)
    journey.complete exit_station
  end

  def list_journeys
    @journeys.dup
  end

  def journey_in_progress?
    @journey ? !journey.complete? : false
  end

  def fare
    fare = journey.fare
    @journey = nil
    fare
  end

  private
  def current_journey(entry_station)
    @journey ||= journey_klass.new(entry_station)
  end
end
