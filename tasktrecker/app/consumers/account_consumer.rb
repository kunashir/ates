  class AccountConsumer < ApplicationConsumer
    def consume
      params_batch.each do |message|
        payload = message.payload
        puts '-' * 80
        p payload
        puts '-' * 80
        data = payload['data']
        # survey = Survey.create(name: data["name"], country_code: data['country_code'], project_id: data['project_id'])
      end
    end
  end
