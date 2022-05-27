require "schema_registry"

namespace :migrate_tasks_to_new_title_format do
  desc "Migrate Task to new format: jira_id + title"
  task tasks_jira_id: :environment do
    Task.all.find_each do |task|
      if task.description =~ /\[(.*)\](.*)/
        task.jira_id = $1
        task.description = $2
        task.save

        event = {
          event_name: 'Task.updated',
          "event_id":      SecureRandom.uuid,
          "event_version": 1,
          "event_time":    Time.now.to_s,
          "producer":      "Task.producer",
          data: {
            public_id: task.public_id,
            account_id: task.account.public_id,
            description: task.description,
            jira_id: task.jira_id,
            created_at: task.created_at.to_s
          }
        }
        result = SchemaRegistry.validate_event(event, 'task.updated', version: 1)
        if result.success?
          WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream')
        end
      end
    end
  end
end
