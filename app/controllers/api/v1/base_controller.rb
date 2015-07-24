class Api::V1::BaseController < ApplicationController
  respond_to :json

  skip_before_action :verify_authenticity_token
  before_action :verify_client_access_token

protected
  def current_client
    return @current_client if defined?(@current_client)
    @current_client = Client.where(access_token: from_access_token_param || from_access_token_header).first
  end

  def from_access_token_param
     request.parameters[:access_token]
  end

  def from_access_token_header
    request.headers['X-Access-Token']
  end

  def verify_client_access_token
    render status: :unauthorized, json: { message: "unauthorized" } if !current_client
  end
end