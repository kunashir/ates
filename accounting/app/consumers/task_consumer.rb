  class TaskConsumer < ApplicationConsumer
    def consume
      params_batch.each do |message|
        payload = message.payload
        puts '-' * 80
        p payload
        puts '-' * 80
        data = payload['data']
        # survey = Survey.create(name: data["name"], country_code: data['country_code'], project_id: data['project_id'])
        case payload["event_name"]
        when 'Task.assigned'
          ActiveRecord::Base.transaction do
            task = Task.find_by(public_id: data["public_id"])
            task = Task.new(public_id: data["public_id"]) unless task
            task.account = Account.find_by(public_id: data["account_id"])
            task.save!
            # we need to change balance of an account when make a transaction
            Transaction.make(account: account, reason: "task-assigned", credit: task.price_assignment)
          end
        when "Task.completed"
          ActiveRecord::Base.transaction do
            task = Task.find_by(public_id: data["public_id"])
            Transaction.make(account: account, reason: "task-completed", debit: task.price_complition)
          end
        end
      end
    end
  end

