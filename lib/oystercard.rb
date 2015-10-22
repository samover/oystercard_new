require_relative 'station'
require_relative 'journey'

class Oystercard

  LIMIT = 90
  DEFAULT_BALANCE = 0

  attr_reader :balance, :entry_station, :journey

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @journey = Journey.new
  end

  def top_up(money)
    fail "The topup limit is £#{LIMIT}" if balance + money > LIMIT
    @balance += money
  end

  def touch_in(entry_station)
    deduct(Journey::PENALTY_FARE) if in_journey?
    fail 'Not enough balance for this journey' if balance < Journey::MINIMUM_FARE
    journey.set_entry_station(entry_station)
  end

  def touch_out(exit_station)
    in_journey? ? deduct(Journey::MINIMUM_FARE) : deduct(Journey::PENALTY_FARE)
    journey.log(exit_station)
    journey.set_entry_station(nil)
  end
  def in_journey?
    journey.in_progress?
  end
private
    def deduct(money)
      @balance -= money
    end
end
