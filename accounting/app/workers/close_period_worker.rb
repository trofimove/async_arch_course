class ClosePeriodWorker
  include Sidekiq::Worker

  def perform
    Balance
      .where(account: { active: true }, role: 'employee')
      .where('balances.amount > 0')
      .each(&:pay)
      .each(&:paid)
  end
end