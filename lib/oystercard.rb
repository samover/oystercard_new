class Oystercard

  LIMIT = 90
  MINIMUM_FARE = 1
  attr_reader :balance

  def initialize
    @balance = 0
    @journey_status = false
  end

  def top_up(money)
    fail "The topup limit is £#{LIMIT}" if @balance + money > LIMIT
    @balance += money
  end

  def deduct(money)
    @balance -= money
  end

  def touch_in
    fail 'Not enough balance for this journey' if balance < MINIMUM_FARE
    @journey_status = true
  end

  def touch_out
    @journey_status = false
  end

  def in_journey?
    @journey_status
  end

end
