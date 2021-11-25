class Account < ActiveRecord::Base
  extend Enumerize

  has_one :balance

  enumerize :role, in: [:admin, :manager, :employee], predicates: true, scope: :shallow

  def transactions_for_day(day)
    self.balance.transactions.where('created_at between ? and ?', day.beginning_of_day, day.end_of_day)
  end
end
