require_relative 'station'

class Oystercard

  LIMIT = 90
  MINIMUM_FARE = 1
  DEFAULT_BALANCE = 0
  PENALTY_FARE = 6

  attr_reader :balance, :entry_station, :journey

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @journey = []
  end

  def top_up(money)
    fail "The topup limit is £#{LIMIT}" if balance + money > LIMIT
    @balance += money
  end

  def touch_in(station)
    deduct(PENALTY_FARE) unless entry_station.nil?
    fail 'Not enough balance for this journey' if balance < MINIMUM_FARE
    @entry_station = station
  end

  def touch_out(exit_station)
    entry_station.nil? ? deduct(PENALTY_FARE) : deduct(MINIMUM_FARE)
    log(exit_station)
    @entry_station = nil
    "#{exit_station}: #{balance}"
  end

  def in_journey?
    !@entry_station.nil?
  end

  def log(exit_station)
    journey << { entry_station => exit_station }
  end

private

    def deduct(money)
      @balance -= money
    end
end
