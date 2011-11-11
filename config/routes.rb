Gitlicious::Application.routes.draw do

  resources :projects do
    resources :metrics
  end

  resources :authors, :only => [] do
    resources :projects, :only => [:index, :show]
  end

  match '/login' => 'sessions#create', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout

  root :to => 'authors#index'

end
