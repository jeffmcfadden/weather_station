class Api::LegacyController < Api::ApplicationController

  def sensor
    @sensor = Sensor.find(params[:id])
    
    respond_to do |format|
      format.html {  }
      format.json { render json: { sensor: @sensor } }
    end
  end
  
  def latest
    @latest_values = {}
    
    Sensor.all.each do |s|
      @latest_values[s.name] = s.latest_value
    end
    
    respond_to do |format|
      format.json { render json: @latest_values }
    end
  end

end
