Rails.application.routes.draw do
  devise_for :users, controllers: { :invitations => 'users/invitations' }

  root to: 'main#root'
  get "/whitelist" => "main#whitelist"
  get "/blacklist" => "main#blacklist"

  resource :profile
  resources :users
  resources :clients
  resources :domain_sets
  resources :host_lists

  namespace :api do
    namespace :v1 do
      resources :users do
        resources :traffics
      end
    end
  end

end
