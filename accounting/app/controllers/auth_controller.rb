class AuthController < ApplicationController
  def callback
    auth_hash = request.env['omniauth.auth']
    account = Account.find_by_auth(auth_hash) || Account.create_with_omniauth(auth_hash)
    AuthIdenty.create_with_omniauth(auth_hash, account)
    if account
      session[:account] = account.id
    end
    redirect_to root_path
  end

  def login
  end

  def logout
    session[:account] = nil
    redirect_to root_path
  end
end
