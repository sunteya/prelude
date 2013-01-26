class UsersController < ApplicationController
  load_and_authorize_resource
  
  def index
    @users = User.all.page(params[:page]).per(5)
  end
  
  def new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to_ok_url_or_default users_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to_ok_url_or_default users_path
    else
      flash[:notice] = "Wrong,Please Try Again"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'User was deleted'
    redirect_to root_url
  end

end
