class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :signed_in_or_out

protected

  def signed_in_or_out
    !!current_user ? 'application' : 'application_signed_out'
  end

private

  def current_user
    @current_user ||= User.find(session[:user]) if session[:user]
  end
  helper_method :current_user

end
