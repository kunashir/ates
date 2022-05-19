class Transaction < ApplicationRecord
  belongs_to :account
  validates :reason, :credit, :debit, presence: true


  scope :today, -> { where("created_at > ?", Date.yesterday) }

  def self.make(account:, reason:, debit: 0, credit: 0)
    account.balance += (debit + credit)
    account.save
    self.create(account: account, reason: reason, debit: debit, credit: credit)
  end

end
