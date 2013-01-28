class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      render "main/access_denied"
    else
      redirect_to new_user_session_path
    end
  end
  
  def redirect_to_ok_url_or_default(default_url)
    url = params[:ok_url].blank? ? default_url : params[:ok_url]
    redirect_to url
  end
  
  def access_denied
  end
end
