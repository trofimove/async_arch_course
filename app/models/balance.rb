class Balance < ApplicationRecord
  extend Enumerize

  belongs_to :account
  has_many :transactions

  def pay
    Transanction.create(balance_id: self.id, amount: self.amount)
  end

  def paid
    self.update(amount: 0)
    PaymentNotifier.notify(self)
    self
  end
end
