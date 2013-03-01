class HomeController < ApplicationController
  def index
    @user = current_user || User.new
    # @user = User.find(3)

    if current_user
      client = LinkedIn::Client.new ENV['LINKEDIN_KEY'], ENV[ 'LINKEDIN_SECRET']
      rtoken = client.request_token.token
      rsecret = client.request_token.secret

      # TODO: we need to cache this so we don't request authorization on every request
      client.authorize_from_access(@user.token, @user.secret)
      
      @picture_url = client.profile(fields: ['picture-url']).picture_url
      # @picture_url = view_context.image_path('shadow-user.jpg')
    end
  end
end
