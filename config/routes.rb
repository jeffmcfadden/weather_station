Rails.application.routes.draw do

  namespace :api do
  end
  namespace :api do
    resources :sensor_observations do
      collection do
        post :create_batch
      end
    end
    
    resources :sensors
    
    get '/legacy/sensors/:id',    to: 'legacy#sensor', as: :legacy_sensor
    get '/legacy/sensors/latest', to: 'legacy#latest', as: :legacy_latest
    
  end
  
  get '/sensors/:id',    to: redirect( "/api/legacy/sensors/%{id}.json" ), constraints: { format: :json }
  get '/sensors/latest', to: redirect( "/api/legacy/sensors/latest.json" ), constraints: { format: :json }
  get '/sensors/latest', to: redirect( "#{ENV['NEW_SENSORS_BASE_URL']}" )
  
  resources :sensors
  resources :sensor_observations
  
  get '/climate', to: 'climate#index', as: :climate
  
  get '/recent_temperatures_for_chart',   to: 'home#recent_temperatures_for_chart', as: :recent_temperatures_for_chart
  get '/recent_highs_and_lows_for_chart', to: 'home#recent_highs_and_lows_for_chart', as: :recent_highs_and_lows_for_chart
  
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
