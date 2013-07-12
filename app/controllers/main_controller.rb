class MainController < ApplicationController
  before_filter :authenticate_user!, except: :grant
  skip_before_action :verify_authenticity_token, only: :grant
  
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
  
  def grant
    if request.post? && params[:token] == "bar"
        FileUtils.touch Rails.root.join("allow/#{request.ip}")
        render 'success'
        return
    end
    
    render 'input'
  end
end
