class HomeController < ApplicationController
  def index
  end
  
  def recent_temperatures_for_chart
    @recent_temperatures = Rails.cache.fetch("v1/recent_temperatures", expires_in: 5.minutes) do
      SensorObservation.where( sensor_id: 1 ).where( "observed_at > ?", (Time.now.in_time_zone - 2.days).beginning_of_day ).collect{ |so| [so.observed_at, (so.value * (9.0/5.0) + 32.0).round(1)] }
    end
    
    # [{name: 'Temperature', data: @recent_temperatures, min: nil, max: nil, library: {borderWidth: 1, lineTension: 0.05, pointRadius: 0}}]
    
    render json: [{name: 'Temperature', data: @recent_temperatures, min: nil, max: nil, library: {borderWidth: 1, lineTension: 0.05, pointRadius: 0, scales: { xAxes: [{gridLines: { display: true }}]}}}]
  end
  
  def recent_highs_and_lows_for_chart
    
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
  
end
