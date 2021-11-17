class SessionsController < ApplicationController
  skip_before_action :check_authorization

  def create
    account = Account.find_by(public_id: request.env.dig("omniauth.auth", "info", "public_id"))
    request.session[:account_id] = account&.id

    redirect_to root_path
  end

  def destroy
    request.session[:account_id] = nil

    redirect_to root_path
  end

  def show
  end
end