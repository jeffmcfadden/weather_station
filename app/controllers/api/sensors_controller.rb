class Api::SensorsController < Api::ApplicationController
  
  def sensor
    @sensor = Sensor.find(params[:id])
    
    respond_to do |format|
      format.html {  }
      format.json { render json: @sensor }
    end
  end
  
  
end
