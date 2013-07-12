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
  post "/grant" => "main#grant"


  namespace :api do
    namespace :v1 do
      resources :users, only: :index do
        patch :batch_update, on: :collection
      end
    end
  end
  
end
