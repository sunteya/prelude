class UserParams < Struct.new(:params, :ability)
  def permit
    params[:user].permit(*permit_attributes) if params[:user]
  end

  def permit_attributes
    if ability.can? :manage, :admin
      [ :email, :login, :password, :password_confirmation, :transfer_remaining ]
    else
      [ :password, :password_confirmation ]
    end
  end
end