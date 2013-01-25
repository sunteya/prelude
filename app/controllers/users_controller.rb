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
  
  ## 更新用户端口号
  def update
    ## 在port表中查询未被租出的端口,并随机选择一个分配给用户
    @user = User.find(params[:id])
    ## 将user当前的端口好接触bind，并在port中更改状态
    current_bind = @user.rents.where(:end_at => nil).first
    current_bind.end_at = Time.now
    current_port = current_bind.port
    current_port.binded = false
    
    ports = Ports.where(:binded => false)
    port_index = rand(ports.size)
    
    bind = Bind.new
    bind.port = ports[port_index]
    bind.user = @user
    bind.start_at = Time.now

    ## 将分配的port的状态修改为binded=true
    ports[ports_index].binded = true

    if current_port.save && @user.save && bind.save
      flash[:notice] = 'User was successfully updated.'
      redirect_to_ok_url_or_default(root_url)
    else
      ## rollback need
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
