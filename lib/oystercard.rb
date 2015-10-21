require_relative 'station'  # => true
require_relative 'journey'  # => true
class Oystercard

  LIMIT = 90           # => 90
  DEFAULT_BALANCE = 0  # => 0

  attr_reader :balance, :entry_station, :journey  # => nil

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance                       # => 20
    @journey = Journey.new                   # => #<Journey:0x007fdd93034210 @history=[]>
  end

  def top_up(money)
    fail "The topup limit is £#{LIMIT}" if balance + money > LIMIT
    @balance += money
  end

  def touch_in(entry_station)
    deduct(Journey::PENALTY_FARE) if in_journey?                                   # => nil
    fail 'Not enough balance for this journey' if balance < Journey::MINIMUM_FARE  # => nil
    journey.set_entry_station(entry_station)                              # => #<struct Station name="Victoria", zone=2>
  end

  def touch_out(exit_station)
    in_journey? ? deduct(Journey::MINIMUM_FARE) : deduct(Journey::PENALTY_FARE)  # => 19
    journey.log(exit_station)                                  # => [{#<struct Station name="Victoria", zone=2>=>#<struct Station name="Aldgate", zone=3>}]
    journey.set_entry_station(nil)                    # => nil
    # "#{exit_station}: #{balance}"
  end
  def in_journey?
    journey.in_progress?
  end
private                                                        # => Oystercard
    def deduct(money)
      @balance -= money                                        # => 19
    end
end              # => #<Journey:0x007fdd93034210 @history=[{#<struct Station name="Victoria", zone=2>=>#<struct Station name="Aldgate", zone=3>}], @entry_station=nil>
