class Task < ApplicationRecord
  extend Enumerize

  belongs_to :account

  enumerize :status, in: [:created, :done], predicates: true, scope: :shallow

  validate :name_doesnt_contain_jira?

  def name_doesnt_contain_jira?
    self.name.blank? || self.name.exclude?('[')
  end
end
