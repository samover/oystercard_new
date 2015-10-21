class Journey
  MINIMUM_FARE = 1     # => 1
  PENALTY_FARE = 6     # => 6

  attr_reader :journey, :history, :entry_station

  def initialize
    @history = []
  end

  def log(exit_station)
    history << { entry_station => exit_station }
  end

  def set_entry_station(entry_station)
    @entry_station = entry_station
  end

  def fare
    return PENALTY_FARE if in_progress?
    return PENALTY_FARE if !@history.empty? && history.last.has_key?(nil)
    MINIMUM_FARE
  end

  def in_progress?
    !entry_station.nil?
  end

end
