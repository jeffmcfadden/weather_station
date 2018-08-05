class ClimateController < ApplicationController

  def index
    if params[:month].present?
      t = Time.new( Time.now.year, params[:month].to_i, 1, 12, 00 )
      @month = t.month
      @month_name = t.strftime("%B")
    else
      @month = Time.now.month
      @month_name = Time.now.strftime("%B")
    end
  end

end
