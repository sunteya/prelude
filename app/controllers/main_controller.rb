class MainController < ApplicationController
  def root
    redirect_to current_user
  end
end
