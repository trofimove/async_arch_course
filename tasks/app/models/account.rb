class Account < ActiveRecord::Base
  extend Enumerize

  enumerize :role, in: [:admin, :manager, :employee], predicates: true, scope: :shallow
end
