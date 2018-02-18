class SensorsController < ApplicationController

  def index
    @sensors = Sensor.all.order( :name )
    
    respond_to do |format|
      format.html {  }
      format.json { render json: @sensors }
    end
  end

  def show
    @sensor = Sensor.find(params[:id])
    
    respond_to do |format|
      format.html {  }
      format.json { render json: { sensor: @sensor } }
    end
  end
    

end
