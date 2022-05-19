class Transaction < ApplicationRecord
  belongs_to :account
  validates :reason, :credit, :debit, present: true

  before_create :set_prices

  def self.make(account:, reason:, debit: 0, credit: 0)
    if debit > 0
      account.balance -= debit
    elsif credit > 0
      account.balance += credit
    end
    account.save
    self.create(account: account, reason: reason, debit: debit, credit: credit)
  end

  private

  def set_prices
    # all prices in cents
    self.assigned_price = -1*rand(10..20) * 100
    self.completion_price = rand(20..40) * 100
  end
end
