class SensorsController < ApplicationController

  def index
    @sensors = Sensor.all.order( :name )
    
    respond_to do |format|
      format.html {  }
    end
  end

  def show
    @sensor = Sensor.find(params[:id])
    
    respond_to do |format|
      format.html {  }
    end
  end
    

end
