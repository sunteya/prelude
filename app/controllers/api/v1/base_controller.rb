class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_client_access_token

protected
  def current_client
    return @current_client if defined?(@current_client)
    @current_client = Client.where(access_token: params[:access_token]).first
  end

  def verify_client_access_token
    render status: :unauthorized, json: { message: "unauthorized" } if !current_client
  end
end