Gitlicious::Application.routes.draw do

  resources :projects do
    resources :reports, :only => :create
    resources :metrics
  end

  match '/login' => 'sessions#create', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout

  root :to => 'sessions#new'

end
