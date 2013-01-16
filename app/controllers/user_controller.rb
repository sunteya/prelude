class UserController < ApplicationController
  def index
    @users = User.all
    # @search = User.search(params[:search])
    # @users = @search.page(params[:page])
  end
end
