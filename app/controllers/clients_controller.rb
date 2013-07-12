class ClientsController < ApplicationController
  load_and_authorize_resource

  def index
    @clients = @clients.page(params[:page]).per(30)
  end

  def new
  end

  def create
    if @client.save
      flash[:notice] = 'Client was successfully created.'
      redirect_to_ok_url_or_default clients_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @client.update_attributes(client_params)
      flash[:notice] = 'Client was successfully updated.'
      redirect_to_ok_url_or_default clients_path
    else
      render 'edit'
    end
  end

  def destroy
    @client.destroy
    flash[:notice] = 'Client was deleted'
    redirect_to_ok_url_or_default clients_path
  end

protected
  def client_params
    params[:client].permit(:access_token, :hostname) if params[:client]
  end

  def resource_params
    client_params
  end

end
