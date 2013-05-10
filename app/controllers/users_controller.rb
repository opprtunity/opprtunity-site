class UsersController < ApplicationController

  class User < ::User
    # we override this method so we can expose nested attributes
    def serializable_hash(options = {})
      super include: [:matches, :needs, :offerings, :upcoming_meetings, :past_meetings]
    end
  end

  def update
    # ideally this submits to the api
    # for now we access the db directly
    @user = User.find(params[:id])

    # This section feels kludgy but we need to translate from industry codes
    # to the text expected by needs/offerings; maybe we need to refactor the
    # database schema
    params[:user][:offerings] = params[:user][:offerings].map do |i|
      industry = Industry.where(description: i).first
      Offering.new(name: industry.description) if industry
    end.compact
    params[:user][:needs] = params[:user][:needs].map do |i|
      industry = Industry.where(description: i).first
      Need.new(name: industry.description) if industry
    end.compact

    respond_to do |format|
      if @user.update_attributes(params[:user])
        @user.registered = true
        @user.save!
        Rails.logger.info  "===finding and processing matches after user update"
        find_and_process_matches(@user)
        format.html { redirect_to :back, notice: 'User successfully updated.' }
      else
        format.html { redirect_to :back, error: 'Sorry, something went wrong.' }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    redirect_to user_slug_path(@user.user_slug)
  end

  def show_by_slug
    @user = User.find_by_user_slug(params[:slug_name])
    render 'home/index'
  end

  # def update_matches

  #   @user = User.find(params[:id])

  #   @matching_users = @user.matching_users

  #   # now queue up for updating the match
  #   for @matching_user in @matching_users
  #     User.delay.update_match(@user.id, @matching_user.id)
  #   end

  #   expose @matching_users

  # end

  def matches
    @user = User.find(params[:id])
  end

  def upcoming
    user = User.find(params[:id])
    expose user.upcoming_meetings
  end

  def past
    user = User.find(params[:id])
    expose user.past_meetings
  end

  def create
    user = User.create!(params[:user])
    expose user
  end

  def destroy
    user = User.find(params[:id])
    user.delete
  end

  private

    def find_and_process_matches(user)
      matching_users = user.matching_users
      Rails.logger.info  "found matching users? #{matching_users.count}"
      # now queue up for updating the match
      for matching_user in matching_users
        Rails.logger.info  ".....adding a match to delayte job: #{user.id} matches #{matching_user.id}"
        User.update_match(user.id, matching_user.id)
      end
    end


end
