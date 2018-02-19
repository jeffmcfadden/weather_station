class GraphDataController < ApplicationController
  
  def recent_temperatures
    @recent_temperatures = Rails.cache.fetch("v1/recent_temperatures", expires_in: 5.minutes) do
      SensorObservation.where( sensor_id: 1 ).where( "observed_at > ?", (Time.now.in_time_zone - 2.days).beginning_of_day ).collect{ |so| [so.observed_at, (so.value * (9.0/5.0) + 32.0).round(1)] }
    end
    
    # [{name: 'Temperature', data: @recent_temperatures, min: nil, max: nil, library: {borderWidth: 1, lineTension: 0.05, pointRadius: 0}}]
    
    render json: [{name: 'Temperature', data: @recent_temperatures, min: nil, max: nil, library: {borderWidth: 1, lineTension: 0.05, pointRadius: 0, scales: { xAxes: [{gridLines: { display: true }}]}}}]
  end
  
  def recent_highs_and_lows
    
    @recent_high_temperatures = Rails.cache.fetch("v1/recent_high_temperatures", expires_in: 5.minutes ) do
      SensorDailyAggregation.where( sensor_id: 1 ).where( "day > ?", 45.days.ago ).collect{ |a| [a.day, a.maximum.to_f * (9.0/5.0) + 32.0] }
    end

    @recent_low_temperatures  = Rails.cache.fetch("v1/recent_low_temperatures", expires_in: 5.minutes ) do
      SensorDailyAggregation.where( sensor_id: 1 ).where( "day > ?", 45.days.ago ).collect{ |a| [a.day, a.minimum.to_f * (9.0/5.0) + 32.0] }
    end
    
    @recent_average_temperatures  = Rails.cache.fetch("v1/recent_average_temperatures", expires_in: 5.minutes ) do
      SensorDailyAggregation.where( sensor_id: 1 ).where( "day > ?", 45.days.ago ).collect{ |a| [a.day, a.average.to_f * (9.0/5.0) + 32.0] }
    end
    
    
    # [{name: 'High Temperature', data: @recent_high_temperatures, library: {lineTension: 0.25, pointRadius: 0, responsive: true, scales: { yAxes: [{ ticks:{ stepSize: 10 } }] }}}, {name: 'Low Temperature', data: @recent_low_temperatures, library: {lineTension: 0.25, pointRadius: 0}}]
    
    render json: [{name: 'High Temperature', data: @recent_high_temperatures, library: {lineTension: 0.25, pointRadius: 0, responsive: true, scales: { yAxes: [{ ticks:{ stepSize: 10 } }] }}}, {name: 'Low Temperature', data: @recent_low_temperatures, library: {lineTension: 0.25, pointRadius: 0}}, {name: 'Average Temperature', data: @recent_average_temperatures, library: {lineTension: 0.25, pointRadius: 0}}]
  end
  
  def highs_and_lows
    
    @range_start = params[:range_start]
    @range_end   = params[:range_end]

    @range_start ||= 45.days.ago
    @range_end   ||= Time.now
    
    @range = @range_start..@range_end
    
    @high_temperatures = SensorDailyAggregation.where( sensor_id: 1 ).where( day: @range ).collect{ |a| [a.day, a.maximum.to_f * (9.0/5.0) + 32.0] }

    @low_temperatures  = SensorDailyAggregation.where( sensor_id: 1 ).where( day: @range ).collect{ |a| [a.day, a.minimum.to_f * (9.0/5.0) + 32.0] }    
    
    render json: [{name: 'High Temperature', data: @high_temperatures, library: {lineTension: 0.25, pointRadius: 0, responsive: true, scales: { yAxes: [{ ticks:{ stepSize: 10 } }] }}}, {name: 'Low Temperature', data: @low_temperatures, library: {lineTension: 0.25, pointRadius: 0}}]
  end
  
  def compare_month
    data = []
    
    (0..3).each do |n|
      range = (Time.now.in_time_zone - n.years).beginning_of_month..(Time.now.in_time_zone - n.years).end_of_month
      temperatures = SensorDailyAggregation.where( sensor_id: 1 ).where( day: range ).collect{ |a| [a.day.strftime("%b %-d"), a.maximum.to_f * (9.0/5.0) + 32.0] }
      
      data << { name: "#{(Time.now.in_time_zone - n.years).year}", data: temperatures, library: {lineTension: 0.25, pointRadius: 0, responsive: true, scales: { yAxes: [{ ticks:{ stepSize: 10 } }] }}}
    end
    
    render json: data
  end
  
  
end
