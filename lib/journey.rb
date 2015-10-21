class Journey

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

end
