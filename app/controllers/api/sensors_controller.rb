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
  
end