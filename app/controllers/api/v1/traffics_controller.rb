class Api::V1::TrafficsController < Api::V1::BaseController
  def create
    @user = User.where(id: params[:user_id]).first
    if @user.nil?
      return render status: :not_found, json: { error_code: 'user_not_found' }
    end

    upcode = params[:traffic].delete(:upcode)
    @traffic = @user.traffics.where(upcode: upcode).first_or_initialize
    @traffic.attributes = traffic_params

    if @traffic.save
      render status: :created
    else
      render status: :unprocessable_entity, json: { message: @traffic.errors.full_messages }
    end
  end

protected
  def traffic_params
    params[:traffic].permit(:start_at, :period, :remote_ip, :incoming_bytes, :outgoing_bytes) if params[:traffic]
  end

end