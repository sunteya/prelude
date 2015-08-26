class UserParams < Struct.new(:ability)
  def permit(params)
    params[:user].permit(*permit_attributes) if params[:user]
  end

  def permit_attributes
    result  = [ :remember_me, :password, :password_confirmation, :invitation_token, :binding_port ]
    result += [ :email, :transfer_remaining, :monthly_transfer, :memo ] if ability.can? :manage, :admin
    result
  end
end
