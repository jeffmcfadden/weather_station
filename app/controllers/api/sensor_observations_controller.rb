class Api::SensorObservationsController < Api::ApplicationController
  
  before_action :verify_api_token, only: [:create, :create_batch]
  
  def create
    observation = create_or_find_sensor_observation
    observation.value = params[:sensor_observation][:value]
    observation.save
    
    respond_to do |format|
      format.html { redirect_to observation, notice: 'Observation saved' }
      format.json { render json: observation, status: :updated, location: observation }
    end
  end
  
  
  # Test with:
  # curl -H "Authorization: Bearer asdf1234" -H "Content-type: application/json" -X POST -d "{\"sensor_observations\":[{\"sensor_id\":1,\"observed_at\":\"2018-02-06T13:44:55Z\",\"value\":12.5},{\"sensor_id\":1,\"observed_at\":\"2018-02-06T13:45:55Z\",\"value\":12.5}]}" http://192.168.201.191/api/sensor_observations/create_batch.json
  
  def create_batch
    records_created_or_updated = 0
    
    begin
      params[:sensor_observations].each do |sensor_observation|
        observation= SensorObservation.find_or_create_by( sensor_id: sensor_observation[:sensor_id], observed_at: sensor_observation[:observed_at] )
        observation.value = sensor_observation[:value].to_f
        observation.save
        records_created_or_updated += 1
      end
      
      respond_to do |format|
        format.html { redirect_to observation, notice: 'Observations saved' }
        format.json { render json: { success: true, records_created_or_updated: records_created_or_updated }, status: :updated }
      end
      
    rescue StandardError => e
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Error: #{e}" }
        format.json { render json: { success: false, records_created_or_updated: records_created_or_updated, error: "#{e}" } }
      end
    end
  end
  
  
  private
  
  def create_or_find_sensor_observation
    SensorObservation.find_or_create_by( sensor_id: params[:sensor_observation][:sensor_id], observed_at: params[:sensor_observation][:observed_at] )
  end
  
  def sensor_observation_params
    params.require( :sensor_observation ).permit( :sensor_id, :observed_at, :value )
  end
    
end
