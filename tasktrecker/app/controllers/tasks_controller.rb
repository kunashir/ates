class TasksController < ApplicationController
  before_action :auth_required

  def index
    @tasks = Task.for_account(current_account)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.account = Account.rand
    if @task.save
        @task.reload
        # ----------------------------- produce event -----------------------
        event = {
          event_name: 'Task.created',
          "event_id":      SecureRandom.uuid,
          "event_version": 2,
          "event_time":    Time.now.to_s,
          "producer":      "Task.producer",
          data: {
            public_id: @task.public_id,
            account_id: @task.account.public_id,
            description: @task.description,
            jira_id: @task.jira_id,
            created_at: @task.created_at.to_s
          }
        }
        result = SchemaRegistry.validate_event(event, 'task.created', version: 2)
        if result.success?
          WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream')
        end
        event = {
          event_name: 'Task.assigned',
          "event_id":      SecureRandom.uuid,
          "event_version": 1,
          "event_time":    Time.now.to_s,
          "producer":      "Task.producer",
          data: {
            public_id: @task.public_id,
            account_id: @task.account.public_id,
          }
        }
        result = SchemaRegistry.validate_event(event, 'task.assigned', version: 1)
        if result.success?
          WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-lifecycle')
        end
        # -------------------------------------------------------------------
      redirect_to tasks_url
    else
      render :new
    end
  end

  def shuffle
    messages = []
    tasks = Task.where(status: :opened).find_each do |task|
      task.account = Account.rand
      if task.save!
        # ----------------------------- produce event -----------------------
        event = {
          event_name: 'Task.assigned',
          data: {
            public_id: task.public_id,
            account_id: task.account.public_id,
          }
        }
        # -------------------------------------------------------------------
        messages << event.to_json
      end
    end
    WaterDrop::BatchSyncProducer.call(messages, topic: 'tasks-lifecycle')
    redirect_to tasks_url
  end

  def close
    task = Task.find(params[:id])
    task.close!
    # ----------------------------- produce event -----------------------
    event = {
      event_name: 'Task.completed',
      data: {
        public_id: task.public_id,
        account_id: task.account.public_id,
      }
    }
    WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-lifecycle')
    # -------------------------------------------------------------------
    redirect_to tasks_url
  end

  private

  def auth_required
    redirect_to login_path unless current_account
  end

  def task_params
    params.require(:task).permit(:description, :jira_id)
  end
end
