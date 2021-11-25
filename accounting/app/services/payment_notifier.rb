class PaymentNotifier
  def self.notify(balance)
    puts "Dear popug #{balance.account.full_name}, you received #{balance.amount} coins"
  end
end