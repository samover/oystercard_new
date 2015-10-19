class Oystercard

  LIMIT = 90
  attr_reader :balance

  def initialize
    @balance = 0
  end

  def top_up(money)
    fail "The topup limit is £#{LIMIT}" if @balance + money > 90
    @balance += money
  end

end
