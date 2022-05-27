  class AccountStreamConsumer < ApplicationConsumer
# {"event_name"=>"AccountUpdated", "data"=>{"public_id"=>"dfd7e181-2e88-4604-8cac-8096
# 7e8a1901", "email"=>"popug1@popug.com", "full_name"=>"Popug1", "position"=>nil}}
    def consume
      params_batch.each do |message|
        payload = message.payload
        puts '-' * 80
        p payload
        puts '-' * 80

        data = payload['data']
        case [payload["event_name"], payload["event_version"]]
        when ["AccountCreated", 1]
          account = Account.new
          account.name = data["full_name"]
          account.public_id = data["public_id"]
          account.role = data["role"]
          account.save!
        when ["AccountUpdated", 1]
          account = Account.find_by(public_id: data["public_id"]) || Account.new
          account.name = data["full_name"]
          account.public_id = data["public_id"]
          account.role = data["role"]
          account.active = data["active"]
          account.save!
        when ["AccountDeleted", 1]
          account = Account.find_by(public_id: data["public_id"])
          account.destroy! if account
        end
      end
    end
  end
