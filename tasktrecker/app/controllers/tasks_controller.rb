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
        # ----------------------------- produce event -----------------------
        event = {
          event_name: 'Task.created',
          data: {
            public_id: @task.public_id,
            account_id: @task.account.public_id,
            description: @task.description,
            created_at: @task.created_at
          }
        }
        WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream')
        event = {
          event_name: 'Task.assigned',
          data: {
            public_id: @task.public_id,
            account_id: @task.account.public_id,
          }
        }
        WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-lifecycle')
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
        messages << event
      end
    end
    WaterDrop::BatchSyncProducer.call(messages, topic: 'tasks')
    redirect_to tasks_url
  end

  def close
    task = Task.find(params[:id])
    task.close!
    # ----------------------------- produce event -----------------------
    event = {
      event_name: 'Task.Completed',
      data: {
        public_id: task.public_id,
        account_id: task.account.public_id,
      }
    }
    WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks')
    # -------------------------------------------------------------------
    redirect_to tasks_url
  end

  private

  def auth_required
    redirect_to login_path unless current_account
  end

  def task_params
    params.require(:task).permit(:description)
  end
end
