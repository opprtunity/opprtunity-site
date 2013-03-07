class OfferingsController < ApplicationController
  before_filter :assign_user

  def index
    expose @user.offerings.paginate(page: params[:page])
  end

  private

  def assign_user
    @user = User.find(params[:user_id])
  end
end
