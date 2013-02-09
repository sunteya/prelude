class Users::InvitationsController < Devise::InvitationsController  
  authorize_object object: :invitation, only: [ :new, :create ]
  
protected
  def resource_params
    user_params.permit
  end
  
  def user_params
    @user_params ||= UserParams.new(params, current_ability)
  end
  helper_method :user_params
  
  def after_invite_path_for(resource)
    users_path
  end
end