class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  
  def redirect_to_ok_url_or_default(default_url)
    url = params[:ok_url].blank? ? default_url : params[:ok_url]
    redirect_to url
  end
end
