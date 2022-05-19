class BillingPeriod < ApplicationRecord
  enum status: [:opened, :closed]

  def self.close!(account, start_date, end_date)
    if account.balance > 0
      ActiveRecord::Base.transaction do
        account.balance = 0
        account.save
        Transaction.make(account: account, reason: "payment", credit: account.balance)
        self.new(start_date: start_date, end_date: end_date, status: :closed).save
      end
      # Mailer.send_notification
    end
  end
end
