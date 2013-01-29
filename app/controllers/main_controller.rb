class MainController < ApplicationController
  # before_filter :authenticate_user!
  
  def root
    redirect_to current_user
  end
  
  def whitelist
    login = request.subdomains.first
    @user = User.where(login: login).first
  end
  
end
