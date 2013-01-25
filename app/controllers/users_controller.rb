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
    ## 在port表中查询未被租出的端口,并随机选择一个分配给用户
    @user = User.find(params[:id])
    ## 将user当前的端口好接触bind，并在port中更改状态
    current_bind = @user.binds.where(:end_at => nil).first
    current_bind.end_at = Time.now
    pre_port = current_bind.port
    
    binding.pry
    
    ports = Port.where(:binded => false)
    port_index = ports.size == 1 ? 0 : rand(ports.size)
    
    bind = Bind.new
    bind.port = ports[port_index]
    bind.user = @user
    bind.start_at = Time.now
    bind_save = bind.save
    
    ## 将分配的port的状态修改为binded=true
    pre_port = Port.find(pre_port.id)
    current_port = Port.find(bind.port.id)
    
    pre_port.binded = false
    current_port.binded = true

    port_save = current_port.save && pre_port.save
    
    if port_save && bind_save && current_bind.save
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
