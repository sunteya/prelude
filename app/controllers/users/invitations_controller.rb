class Users::InvitationsController < Devise::InvitationsController
  authorize_object object: :invitation, only: [ :new, :create ]

protected
  def user_params
    UserParams.new(current_ability).permit(params)
  end

  def after_invite_path_for(resource)
    users_path
  end
end