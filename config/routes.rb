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
  
  get '/climate', to: 'climate#index', as: :climate
  
  get '/recent_temperatures_for_chart',   to: 'home#recent_temperatures_for_chart', as: :recent_temperatures_for_chart
  get '/recent_highs_and_lows_for_chart', to: 'home#recent_highs_and_lows_for_chart', as: :recent_highs_and_lows_for_chart
  
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
