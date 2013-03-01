class Api::UsersController < Api::ApiController
  
  class User < ::User
    # we override this method so we can expose nested attributes
    def serializable_hash(options = {})
      super include: [:matches, :needs, :offerings, :upcoming_meetings, :past_meetings]
    end
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

  def index
    # note that we're using the unmodified model here so we don't expose any of
    # the nested attributes at the index
    expose ::User.paginate(page: params[:page])
  end

  def show
    expose User.find(params[:id])
  end

  def create
    user = User.create!(params[:user])
    expose user
  end

  def update
    user = User.find(params[:id])
    user.update_attributes!(params[:user])
    expose user
  end

  def destroy
    user = User.find(params[:id])
    user.delete
  end
end
