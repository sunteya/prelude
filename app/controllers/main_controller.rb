class MainController < ApplicationController
  before_filter :authenticate_user!, only: [ :root, :whitelist ]
  
  def root
    redirect_to current_user
  end
  
  def whitelist
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
