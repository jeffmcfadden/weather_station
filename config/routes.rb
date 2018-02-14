Rails.application.routes.draw do

  namespace :api do
    resources :sensor_observations do
      collection do
        post :create_batch
      end
    end
  end
  
  resources :sensors
  resources :sensor_observations
  
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
