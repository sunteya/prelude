class Api::V1::UsersController < Api::V1::BaseController
  def index
    @users = User.available
  end
end
