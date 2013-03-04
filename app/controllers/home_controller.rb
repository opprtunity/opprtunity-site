class HomeController < ApplicationController
  def index
    @user = current_user || User.new
  end

  def about
    render :layout => 'application'
  end

  def contact
    render :layout => 'application'
  end  
end
