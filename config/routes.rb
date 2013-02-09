Prelude::Application.routes.draw do
  devise_for :users, :controllers => { :invitations => 'users/invitations' }
  root :to => 'main#root'
  
  resource :profile
  resources :users do
    resource :binding
  end
  
  get "/whitelist" => "main#whitelist"
  get "/blacklist" => "main#blacklist"
  match "/grant" => "main#grant"
  
end
