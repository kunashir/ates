class Account < ApplicationRecord
  has_many :auth_identies, class_name: "AuthIdenty", dependent: :destroy

  def self.find_by_auth(auth)
    accounts = self.joins(:auth_identies)
      .where(auth_identies: { provider: auth["provider"], uid: auth["uid"] })
      .where(public_id: auth["info"]["public_id"])
    return unless accounts.any?
    accounts.first
  end

  def self.create_with_omniauth(auth)
    account = self.new
    account.public_id = auth["info"]["public_id"]
    account.name = auth["info"]["full_name"]
    account.active = auth["info"]["active"]
    account.role = auth["info"]["role"]
    account.save!
    account
  end

  def self.rand
    Account.find(Account.pluck(:id).sample)
  end

  def admin?
    role == "admin"
  end

  def to_s
    name
  end
end
