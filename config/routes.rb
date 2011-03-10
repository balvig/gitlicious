Gitlicious::Application.routes.draw do
  resources :tags

  resources :projects do
    put :import_tags, :on => :member
    resources :tags, :only => [:show,:edit,:update]
  end
  
  root :to => "projects#index"

end
