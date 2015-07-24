class ClientsController < ApplicationController
  load_and_authorize_resource

  def index
    @clients = @clients.page(params[:page]).per(30)
  end

  def new
  end

  def create
    @client.save
    respond_with @client, location: -> { ok_url_or_default clients_path }
  end

  def edit
  end

  def update
    @client.update(client_params)
    respond_with @client, location: -> { ok_url_or_default clients_path }
  end

  def destroy
    @client.destroy
    flash[:notice] = 'Client was deleted'
    redirect_to_ok_url_or_default clients_path
  end

protected
  def client_params
    params[:client].permit(:access_token, :hostname, :disabled) if params[:client]
  end

  def resource_params
    client_params
  end

end
