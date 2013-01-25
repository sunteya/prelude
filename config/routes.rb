Prelude::Application.routes.draw do
  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  get "main/root"
  root :to => 'main#root'

  resources :users do
    resources :statistics
    resources :cdrs
  end
  
  

end
