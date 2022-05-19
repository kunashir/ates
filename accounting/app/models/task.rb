class Task < ApplicationRecord
  belongs_to :account
  before_create :set_prices

  validates  :account, presence: true
  enum status: {
    opened: "opened",
    closed: "closed"
  }

  private

  def set_prices
    # all prices in cents
    self.price_assignment = -1*rand(10..20) * 100
    self.price_complition = rand(20..40) * 100
  end
end
