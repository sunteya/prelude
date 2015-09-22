class MainController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :authenticate_user!

  def root
    redirect_to current_user
  end

  def access_denied
  end

  def whitelist
    @host_list = current_user.host_list(:white)
    redirect_to [ @host_list, format: params[:format] ], status: :moved_permanently
  end

  def blacklist
    @host_list = current_user.host_list(:black)
    redirect_to [ @host_list, format: params[:format] ], status: :moved_permanently
  end
end
