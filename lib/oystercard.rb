require_relative 'station'  # => true
require_relative 'journey'  # => true
class Oystercard

  LIMIT = 90           # => 90
  MINIMUM_FARE = 1     # => 1
  DEFAULT_BALANCE = 0  # => 0
  PENALTY_FARE = 6     # => 6

  attr_reader :balance, :entry_station, :journey  # => nil

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance                       # => 20
    @journey = Journey.new                   # => #<Journey:0x007fb4c4089078 @history=[]>
  end

  def top_up(money)
    fail "The topup limit is £#{LIMIT}" if balance + money > LIMIT
    @balance += money
  end

  def touch_in(entry_station)
    deduct(PENALTY_FARE) if in_journey?                                   # => nil
    fail 'Not enough balance for this journey' if balance < MINIMUM_FARE  # => nil
    journey.set_entry_station(entry_station)                              # => #<struct Station name="Victoria", zone=2>
  end

  def touch_out(exit_station)
    in_journey? ? deduct(MINIMUM_FARE) : deduct(PENALTY_FARE)  # => 19
    journey.log(exit_station)                                  # => [{#<struct Station name="Victoria", zone=2>=>#<struct Station name="Aldgate", zone=3>}]
    journey.set_entry_station(nil)                    # => #<struct Station name="Aldgate", zone=3>
    # "#{exit_station}: #{balance}"
  end
  def in_journey?
    !journey.entry_station.nil?
  end
private                                                        # => Oystercard
    def deduct(money)
      @balance -= money                                        # => 19
    end
end

card = Oystercard.new(20)          # => #<Oystercard:0x007fb4c4089168 @balance=20, @journey=#<Journey:0x007fb4c4089078 @history=[]>>
card.touch_in STATIONS[:victoria]  # => #<struct Station name="Victoria", zone=2>
card.touch_out STATIONS[:aldgate]  # => #<struct Station name="Aldgate", zone=3>
card.journey                       # => #<Journey:0x007fb4c4089078 @history=[{#<struct Station name="Victoria", zone=2>=>#<struct Station name="Aldgate", zone=3>}], @entry_station=#<struct Station name="Aldgate", zone=3>>

# >> nil
# >> #<struct Station name="Victoria", zone=2>
