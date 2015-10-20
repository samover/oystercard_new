class Oystercard

  LIMIT = 90
  MINIMUM_FARE = 1
  attr_reader :balance, :entry_station

  def initialize
    @balance = 0
  end

  def top_up(money)
    fail "The topup limit is £#{LIMIT}" if @balance + money > LIMIT
    @balance += money
  end

  def touch_in(station)
    fail 'Not enough balance for this journey' if balance < MINIMUM_FARE
    @entry_station = station
  end

  def touch_out
    @entry_station = nil
    deduct(MINIMUM_FARE)
  end

  def in_journey?
    @entry_station.exist?
  end

private

    def deduct(money)
      @balance -= money
    end
end
