class Transaction < ApplicationRecord
  extend Enumerize

  has_one :balance
  has_one :task

  enumerize :status, in: [:not_paid, :paid]
end
