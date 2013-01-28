class BindingsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    binding = @user.binding
    if binding && binding.port
      binding.close
      binding = @user.binds.create
    end
    
    redirect_to @user
  end
end
