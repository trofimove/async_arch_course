class Task < ApplicationRecord
  extend Enumerize

  enumerize :status, in: [:created, :done], predicates: true, scope: :shallow
end
