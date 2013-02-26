class UserParams < Struct.new(:params, :ability)
  def permit
    params[:user].permit(*permit_attributes) if params[:user]
  end

  def permit_attributes
    if ability.can? :manage, :admin
      [ :email, :password, :password_confirmation, :transfer_remaining, :monthly_transfer ]
    else
      [ :password, :password_confirmation, :invitation_token ]
    end
  end
end
