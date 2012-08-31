require "fileutils"
require "pry"
require 'sinatra/base'

class App < Sinatra::Base
  set :views, 'views'
  set :public_folder, 'public'
  
  get '/' do
    erb :input
  end
  
  get '/success' do
    erb :success
  end
  
  post '/grant' do
    if params[:token] == "1337"
      FileUtils.touch "#{settings.root}/allow/#{request.ip}"
      erb :success
    else
      erb :input
    end
  end
end

run App