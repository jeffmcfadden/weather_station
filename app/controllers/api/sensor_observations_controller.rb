class Api::SensorObservationsController < Api::ApplicationController
  
  before_action :verify_api_token, only: [:create]
  
  def create
    observation = create_or_find_sensor_observation
    observation.value = params[:sensor_observation][:value]
    observation.save
    
    respond_to do |format|
      format.html { redirect_to observation, notice: 'Observation saved' }
      format.json { render json: observation, status: :updated, location: observation }
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
