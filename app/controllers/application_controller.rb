class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      render "main/access_denied"
    else
      redirect_to new_user_session_path
    end
  end

  def redirect_to_ok_url_or_default(default)
    redirect_to params[:ok_url] || default
  end
end
