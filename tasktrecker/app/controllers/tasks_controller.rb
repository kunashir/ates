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
      redirect_to tasks_url
    else
      render :new
    end
  end

  def suffle
  end

  def close
  end

  private

  def auth_required
    redirect_to login_path unless current_account
  end

  def task_params
    params.require(:task).permit(:description)
  end
end
