Gitlicious::Application.routes.draw do

  resources :projects do
    resources :reports, :only => :create
    resources :metrics
  end

  resources :authors, :only => [:index,:show] do
    resources :projects
  end

  root :to => "authors#index"

end