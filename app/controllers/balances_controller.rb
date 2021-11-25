class BalancesController < ApplicationController
  def index
    @transactions = current_account.transactions_for_day(Time.now)

    @week_data = {}
    (0..6).each do |i|
      date = Time.now - i.days
      @week_data[date] = income_for_day(date.beginning_of_day)
    end

  end

  private

  def income_for_day(day)
    Account.employee.to_a.map { |a| a.transactions_for_day(day) }.flatten
           .map(&:amount)
           .select { |a| a.positive? }
           .sum(:balance)
  end

end
