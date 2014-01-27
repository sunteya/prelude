class UsersController < ApplicationController
  def index
    @users = User.all.page(params[:page]).per(5)
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    params[:user][:port] = rand(10000) + 20000 if can? :manage, :all
    binding.pry
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to_ok_url_or_default(root_url)
    else
      flash[:notice] = "Wrong,Please Try Again"
      render action: "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'User was deleted'
    redirect_to root_url
  end

end
