class HostListsController < ApplicationController
  def show
    expires_in 1.hours, public: true
    @host_list = HostList.find_by(token: params[:id])
    @user = @host_list.user
    request.variant = @host_list.policy
  end
end
