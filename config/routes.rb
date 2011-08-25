Gitlicious::Application.routes.draw do
  resources :projects do
    put :import_commits, :on => :member
    resources :commits, :only => [:show]
  end
  
  root :to => "projects#index"

end
