require "fileutils"
require 'sinatra/base'
require File.expand_path("../../config/secret.rb", __FILE__)

class ServerApp < Sinatra::Base
  set :root, File.expand_path("../../", __FILE__)
  set :views, 'views'
  set :public_folder, 'public'
  
  get '/' do
    erb :input
  end
  
  get '/success' do
    erb :success
  end
  
  post '/grant' do
    if SECRET.include?(params[:token])
      FileUtils.touch "#{settings.root}/allow/#{request.ip}"
      redirect to('/success')
    else
      erb :input
    end
  end
end