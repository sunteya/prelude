require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      render "main/access_denied"
    else
      redirect_to new_user_session_path
    end
  end

  def redirect_to_ok_url_or_default(default_url)
    redirect_to ok_url_or_default(default_url)
  end

  def ok_url_or_default(default_url)
    params[:ok_url] || default_url
  end

  def authenticate_user_from_token!
    auth_token = params[:auth_token].presence
    user = auth_token && User.find_by_authentication_token(auth_token.to_s)

    if user
      sign_in user, store: false
    end
  end
end
