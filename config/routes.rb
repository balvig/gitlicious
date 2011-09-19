Gitlicious::Application.routes.draw do

  resources :projects do
    put :import_commits, :on => :member
    resources :commits, :only => :show
    resources :metrics
  end
  
  resources :authors, :only => [:index,:show] do
    resources :projects
  end
  
  root :to => "authors#index"

end