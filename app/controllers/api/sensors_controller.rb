class Api::SensorsController < Api::ApplicationController
  
  def index
    @sensors = Sensor.all
    
    respond_to do |format|
      format.json { render json: @sensors }
    end
  end
  
  def show
    @sensor = Sensor.find(params[:id])
    
    respond_to do |format|
      format.json { render json: @sensor }
    end
  end
  
  def latest_values
    @latest_values = {}
    
    Sensor.all.each do |s|
      @latest_values[s.name] = s.latest_value
    end
    
    respond_to do |format|
      format.json { render json: @latest_values }
    end
  end
  
end