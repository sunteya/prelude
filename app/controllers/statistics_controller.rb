class StatisticsController < ApplicationController
  before_filter :find_user
  
  def index
    binding.pry
      @user = User.find(params[:user_id])
      @query_way = params[:query_way] || "h"
      @statistics = @user.statistics.page(params[:page])
      
      if @query_way == "h"
      #last two hours size
      else
        if @query_way == "d"
        #today size
          
        end
        #this month size
      end
  end
  
  private
  def find_user
    @user = User.find(params[:user_id])
  end
end