Petparent::Application.routes.draw do

  #scope '/admin' do
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
    end
  end
  resources :tips
  resources :tags
  resources :pets
  resources :lost_pets
  resources :events

  resources :photos do
    collection do
      get 'create_parse_image'
    end
  end

end
