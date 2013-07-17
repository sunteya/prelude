class MainController < ApplicationController
  before_filter :authenticate_user!
  
  def root
    redirect_to current_user
  end

  def access_denied
  end
  
  def whitelist
    expires_in 1.hour, public: true
    @user = current_user
  end
  
  def blacklist
    expires_in 1.hour, public: true
    @user = current_user
  end
end
