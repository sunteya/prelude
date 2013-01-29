Prelude::Application.routes.draw do
  devise_for :users, :path => '', :path_names => { sign_in: 'sign_in', sign_out: 'sign_out' }
  root :to => 'main#root'
  
  resource :profile
  resources :users do
    resource :binding
  end
  
  get "/whitelist" => "main#whitelist"
  get "/blacklist" => "main#blacklist"
  
end
