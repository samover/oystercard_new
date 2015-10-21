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
    if in_progress?
      return PENALTY_FARE if entry_station
    elsif !@history.empty?
      return PENALTY_FARE if history.last.has_key?(nil)
    else
      return MINIMUM_FARE
    end
  end

  def in_progress?
    !entry_station.nil?
  end

end
