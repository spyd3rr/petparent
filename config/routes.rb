Petparent::Application.routes.draw do


  get "log_in" => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"  
  
  get "sign_up" => "users#new", :as => "sign_up"  
  root :to => "sessions#new"
  resources :users  
  resources :sessions

  resources :venues do
    collection do
      get 'find'
      post 'upload_images'
    end
    member do
      get 'delete_venue_photo'
      post 'edit2update'
      get 'edit2'
    end
  end
  resources :tips
  resources :tags
  resources :pets
  resources :lost_pets
  resources :events do
    collection do
      post 'upload_images'
    end
    member do
      get 'delete_event_photo'
    end
  end
  resources :photos

end
