class MainController < ApplicationController
  before_filter :authenticate_user!
  
  def root
    redirect_to current_user
  end
end
