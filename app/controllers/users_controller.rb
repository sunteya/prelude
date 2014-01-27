class UsersController < ApplicationController
  load_and_authorize_resource
  
  def index
    @users = User.page(params[:page]).per(5)
  end
  
  def new
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
    @user = User.find(params[:id])
    begin
      ## 找到用户当前使用端口绑定，并终止该绑定
      c_bind = @user.binds.where(:end_at => nil).first
      c_bind.update_attributes(:end_at => Time.now)
      c_port = c_bind.port
      
      ## 在port表中查询未被租出的端口,并随机选择一个分配给用户
      ports = Port.where(:binded => false)
      c_port.update_attributes(:binded => false)
      
      port_index = ports.size == 1 ? 0 : rand(ports.size)
      t_port = Port.find(ports[port_index].id)
      
      bind = Bind.new
      bind.port = t_port
      bind.user = @user
      bind.start_at = Time.now
      bind.save

      t_port.update_attributes(:binded => true)
      c_port.update_attributes(:binded => false)
      flash[:notice] = 'User was successfully updated.'
      redirect_to_ok_url_or_default(root_url)
    rescue Exception => e
      flash[:notice] = 'User was successfully updated.'
      redirect_to_ok_url_or_default users_path
    else
      flash[:notice] = "Wrong,Please Try Again"
      redirect_to_ok_url_or_default users_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'User was deleted'
    redirect_to_ok_url_or_default users_path
  end
  
protected
  def resource_params
    user_params.permit
  end
  
  def user_params
    UserParams.new(params, current_ability)
  end
  helper_method :user_params
  
end
