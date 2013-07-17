Prelude::Application.routes.draw do
  devise_for :users, :controllers => { :invitations => 'users/invitations' }
  root :to => 'main#root'
  
  resource :profile
  
  resources :users do
    resource :binding
  end
  resources :clients
  
  get "/whitelist" => "main#whitelist"
  get "/blacklist" => "main#blacklist"


  namespace :api do
    namespace :v1 do
      resources :users do
        resources :traffics
      end
    end
  end
  
end
