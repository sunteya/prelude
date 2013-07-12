class UsersController < ApplicationController
  load_and_authorize_resource
  
  def index
    @users = @users.page(params[:page]).per(30)
  end
  
  def new
  end
  
  def show
    @now = Time.now
    @recent_report = TrafficReport::Minutely.recent(@user.traffics)
    @today_report = TrafficReport::Hourly.today(@user.traffics)
    @this_month_report = TrafficReport::Daily.this_month(@user.traffics)
  end
  
  def create
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
    if @user.update_attributes(user_params.permit)
      flash[:notice] = 'User was successfully updated.'
      redirect_to_ok_url_or_default users_path
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = 'User was deleted'
    redirect_to_ok_url_or_default users_path
  end
  
protected
  def resource_params
    user_params.permit
  end
  
  def user_params
    @user_params ||= UserParams.new(params, current_ability)
  end
  helper_method :user_params
  
end
