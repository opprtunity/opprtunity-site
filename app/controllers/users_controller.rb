class UsersController < ApplicationController
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

    if current_user && current_user.id == @user.id
      client = LinkedIn::Client.new ENV['LINKEDIN_KEY'], ENV[ 'LINKEDIN_SECRET']
      rtoken = client.request_token.token
      rsecret = client.request_token.secret

      # TODO: we need to cache this so we don't request authorization on every request
      client.authorize_from_access(@user.token, @user.secret)
      
      @picture_url = client.profile(fields: ['picture-url']).picture_url
      # @picture_url = view_context.image_path('shadow-user.jpg')
    else
      @picture_url = view_context.image_path('shadow-user.jpg')
    end

    render 'home/index'
  end
end