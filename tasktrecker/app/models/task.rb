class Task < ApplicationRecord
  belongs_to :account

  validates :description, :account, presence: true
  enum role: {
    opened: "opened",
    closed: "closed"
  }

  def self.for_account(account)
    if account.admin?
      where(status: :opened)
    else
      where(account: account, status: :opened)
    end
  end
end