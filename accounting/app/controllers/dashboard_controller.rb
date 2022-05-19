class DashboardController < ApplicationController
  before_action :auth_required

  def main
    if current_account.admin?
      redirect_to dashboard_manager_path
    else
      redirect_to dashboard_popug_path
    end
  end

  def popug
    @current_balance = current_account.balance / 100
    @transcations = Transaction.where(account: current_account).today
  end

  def manager
    redirect_to dashboard_popug_path and return unless current_account.admin?
    @assigned_transactions_sum = Transaction.where(reason: "task-assigned").today.sum(:credit) / 100
    @completed_transactions_sum = Transaction.where(reason: "task-completed").today.sum(:debit) / 100
  end

  private

  def auth_required
    redirect_to login_path unless current_account
  end
end
