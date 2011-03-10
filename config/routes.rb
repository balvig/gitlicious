Gitlicious::Application.routes.draw do
  resources :tags

  resources :projects do
    resources :tags, :only => [:show,:edit,:update]
  end
  
  root :to => "projects#index"

end
