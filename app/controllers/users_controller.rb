class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @q = User.search(params[:q])
    @q.sorts = 'email asc' if @q.sorts.empty?
    @users = @q.result.page(params[:page]).per(30)
  end

  def new
  end

  def show
    @now = Time.zone.now
    @recent_report = TrafficReport::Minutely.recent(@user.traffics)
    @today_report = TrafficReport::Hourly.today(@user.traffics)
    @this_month_report = TrafficReport::Daily.this_month(@user.traffics)
  end

  def create
    @user.save
    respond_with @user, location: -> { ok_url_or_default users_path }
  end

  def edit
  end

  def update
    @user.update(user_params.permit)
    respond_with @user, location: -> { ok_url_or_default users_path }
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
