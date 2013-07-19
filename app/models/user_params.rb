class UserParams < Struct.new(:params, :ability)
  def permit
    params[:user].permit(*permit_attributes) if params[:user]
  end

  def permit_attributes
    result  = [ :remember_me, :password, :password_confirmation, :invitation_token, :binding_port ]
    result += [ :email, :transfer_remaining, :monthly_transfer, :memo ] if ability.can? :manage, :admin
    result
  end
end
