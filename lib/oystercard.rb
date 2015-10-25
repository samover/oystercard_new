require_relative 'station'
require_relative 'journey'

class Oystercard
  DEF_BALANCE = 0
  MAX_BALANCE = 90
  MIN_FARE = 1

  attr_reader :balance, :entry_station, :exit_station, :journeys, :journey_klass, :journey

  def initialize(balance: DEF_BALANCE, journey_klass: Journey)
    @balance = balance
    @journeys = []
    @journey_klass = journey_klass
  end

  def topup value
    fail "Max of #{MAX_BALANCE} exceeded" if balance + value > MAX_BALANCE
    @balance += value
  end

  def touch_in entry_station
    touch_out(nil) if in_journey?
    fail 'Insufficient balance' if insufficient?
    @journey = journey_klass.new(entry_station: entry_station)
  end

  def touch_out exit_station
    touch_in(nil) unless in_journey?
    journey.complete(exit_station)
    deduct(journey.fare)
    journeys << journey
  end

  def in_journey?
    return false unless instance_variable_defined?(:@journey)
    !journey.complete?
  end

  private
  def insufficient?
    balance < MIN_FARE
  end

  def deduct fare
    @balance -= fare
  end
end

# c = Oystercard.new(balance: 20, journey_klass: Journey)  # => #<Oystercard:0x007fd0b202b040 @balance=20, @journeys=[], @journey_klass=Journey>
# c.touch_in STATIONS[:victoria]                           # => #<Journey:0x007fd0b202a578 @entry_station=#<struct Station name="Victoria", zone=1>>
# c.balance                                                # => 20
# c.touch_in STATIONS[:victoria]                           # => #<Journey:0x007fd0b2029600 @entry_station=#<struct Station name="Victoria", zone=1>>
# c.balance                                                # => 14
# c.touch_in STATIONS[:victoria]                           # => #<Journey:0x007fd0b20288e0 @entry_station=#<struct Station name="Victoria", zone=1>>
# c.balance                                                # => 8
# c.touch_out STATIONS[:aldgate]                           # => [#<Journey:0x007fd0b202a578 @entry_station=#<struct Station name="Victoria", zone=1>, @exit_station=nil>, #<Journey:0x007fd0b2029600 @entry_station=#<struct Station name="Victoria", zone=1>, @exit_station=nil>, #<Journey:0x007fd0b20288e0 @entry_station=#<struct Station name="Victoria", zone=1>, @exit_station=#<struct Station name="Aldgate East", zone=1>>]
# c.balance                                                # => 7
# c.touch_out STATIONS[:victoria]                          # => [#<Journey:0x007fd0b202a578 @entry_station=#<struct Station name="Victoria", zone=1>, @exit_station=nil>, #<Journey:0x007fd0b2029600 @entry_station=#<struct Station name="Victoria", zone=1>, @exit_station=nil>, #<Journey:0x007fd0b20288e0 @entry_station=#<struct Station name="Victoria", zone=1>, @exit_station=#<struct Station name="Aldgate East", zone=1>>, #<Journey:0x007fd0b2023598 @entry_station=nil, @exit_station=#<struct Station name="Victoria", zone=1>>]
# c.balance                                                # => 1
# c.touch_out STATIONS[:victoria]                          # => [#<Journey:0x007fd0b202a578 @entry_station=#<struct Station name="Victoria", zone=1>, @exit_station=nil>, #<Journey:0x007fd0b2029600 @entry_station=#<struct Station name="Victoria", zone=1>, @exit_station=nil>, #<Journey:0x007fd0b20288e0 @entry_station=#<struct Station name="Victoria", zone=1>, @exit_station=#<struct Station name="Aldgate East", zone=1>>, #<Journey:0x007fd0b2023598 @entry_station=nil, @exit_station=#<struct Station name="Victoria", zone=1>>, #<Journey:0x007fd0b2023598 @entry_station=nil, @exit_station=#<struct Station name="Victoria", zone=1>>]
# c.balance                                                # => -5
# c.touch_in STATIONS[:victoria]
