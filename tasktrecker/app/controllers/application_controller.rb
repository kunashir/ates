class ApplicationController < ActionController::Base
  helper_method :current_account

  private

  def current_account
    @current_account ||= Account.find(session[:account]) if session[:account]
  end
end
