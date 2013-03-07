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
        format.html { redirect_to :back, notice: 'User successfully updated.' }
      else
        format.html { redirect_to :back, error: 'Sorry, something went wrong.' }
      end
    end
  end

  def show
    @user = User.find params[:id]
    render 'home/index'
  end

  def update_matches

    @user = User.find(params[:id])

    offerings = []
    for o in @user.offerings
      offerings.push(o.name)
    end

    needs = []
    for n in @user.needs
      needs.push(n.name)
    end

    # find other users
    # - who needs this user's offers or who offers this user's needs
    # - and are within certain radius
    @matching_users = User.uniq
      .joins(:needs)
      .joins(:offerings)
      .where("needs.name IN (:offerings) OR offerings.name In (:needs)", :offerings => offerings, :needs => needs)
      .where("users.id != ?", @user.id)
      .near(@user.zip_code, 50)

    for matching_user in @matching_users
      MatchesController.delay.update_match(@user.id, matching_user.id)
    end

    expose @matching_users

  end  

  def matches
    user = User.find(params[:id])
    expose user.matches
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


end