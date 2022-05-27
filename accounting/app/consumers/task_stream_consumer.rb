  class TaskStreamConsumer < ApplicationConsumer
    def consume
      params_batch.each do |message|
        payload = message.payload
        puts '-' * 80
        p payload
        puts '-' * 80
        data = payload['data']
        case [payload["event_name"], payload["event_version"]]
        when ['Task.created', 1]
          return unless data["public_id"]

          task = Task.find_by(public_id: data["public_id"])
          task = Task.new(public_id: data["public_id"]) unless task
          task.description = data["description"]
          task.created_at = data["created_at"]
          task.account = Account.find_by(public_id: data["account_id"])
          task.save!
        when ['Task.created', 2]
          return unless data["public_id"]

          task = Task.find_by(public_id: data["public_id"])
          task = Task.new(public_id: data["public_id"]) unless task
          task.jira_id = data["jira_id"]
          task.description = data["description"]
          task.created_at = data["created_at"]
          task.account = Account.find_by(public_id: data["account_id"])
          task.save!
        when ['Task.updated', 1]
          return unless data["public_id"]

          task = Task.find_by(public_id: data["public_id"])
          task = Task.new(public_id: data["public_id"]) unless task
          task.jira_id = data["jira_id"]
          task.description = data["description"]
          task.created_at = data["created_at"]
          task.account = Account.find_by(public_id: data["account_id"])
          task.save!
        end
      end
    end
  end

