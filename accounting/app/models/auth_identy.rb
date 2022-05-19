class AuthIdenty < ApplicationRecord
  belongs_to :account

  def self.create_with_omniauth(auth, account)
    # {"provider":"keepa","uid":"ebdb69c5-6f32-450a-89d8-79ffb6b6418e","info":{"email":"kunash123@gmail.com","full_name":"ME","position":null,"active":true,"role":"admin","public_id":"ebdb69c5-6f32-450a-89d8-79ffb6b6418e","name":"kunash123@gmail.com"},"credentials":{"token":"2hgpid-J-CgtUMWgD9Yz5wYxwVuLjodDRha3bifjAA8","expires_at":1652261961,"expires":true},"extra":{}}
    record = self.new(
      account: account,
      uid: auth['uid'],
      provider: auth['provider'],
      login: auth['info']['email'],
      token: auth['credentials']["token"]
    )
    record.save
  end
end
