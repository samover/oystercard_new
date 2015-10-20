class Oystercard

  LIMIT = 90
  attr_reader :balance

  def initialize
    @balance = 0
    @journey_status = false
  end

  def top_up(money)
    fail "The topup limit is £#{LIMIT}" if @balance + money > 90
    @balance += money
  end

  def deduct(money)
    @balance -= money
  end

  def touch_in
    @journey_status = true
  end

  def touch_out
    @journey_status = false
  end

  def in_journey?
    @journey_status
  end

end
