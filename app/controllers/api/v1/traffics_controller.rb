class Api::V1::TrafficsController < Api::V1::BaseController
  def create
    @user = User.find(params[:user_id])
    upcode = params[:traffic][:upcode]
    @traffic = @user.traffics.where(upcode: upcode).first_or_initialize
    @traffic.attributes = traffic_params
    @traffic.calculate_transfer_remaining = true

    if @traffic.save
      render status: :created, json: {}
    else
      render status: :unprocessable_entity, json: { message: @traffic.errors.full_messages }
    end
  end

protected
  def traffic_params
    params[:traffic].permit(:start_at, :period, :remote_ip, :incoming_bytes, :outgoing_bytes) if params[:traffic]
  end

end