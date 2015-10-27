class Journey
  MIN_FARE = 1
  PENALTY_FARE = 6

  attr_reader :entry_station, :exit_station

  def initialize(entry_station)
    @entry_station = entry_station
  end

  def complete(exit_station)
    @exit_station = exit_station
  end

  def fare
    return MIN_FARE if complete?
    PENALTY_FARE
  end

  def complete?
    entry_station && exit_station
  end
end
