class SessionsController < ApplicationController
  def create
    puts auth_hash['extra']['raw_info']['location']['name'].to_yaml
    session[:user] = User.create_from_auth_hash(auth_hash, request.ip).id
    redirect_to root_url, notice: 'Signed in!'
  end

  def destroy
    session[:user] = nil
    redirect_to root_url, notice: 'Signed out!'
  end

  def failure
    # TODO
    redirect_to root_url, error: 'Failure!'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end