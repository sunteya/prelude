class BindingsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    binding = @user.binding
    if binding && binding.port
      binding.close
      binding = nil
    end
    
    binding ||= @user.binds.create
    redirect_to @user
  end
end
