Prelude::Application.routes.draw do
  devise_for :users, :path => '', :path_names => { sign_in: 'login', sign_out: 'logout' }
  root :to => 'main#root'
  
  # resources :users do
    # resources :statistics
    # resources :cdrs
  # end
  
  get "/whitelist.pac" => "main#whitelist", as: :whitelist
  get "/blacklist.pac" => "main#blacklist", as: :blacklist
  
  
end
