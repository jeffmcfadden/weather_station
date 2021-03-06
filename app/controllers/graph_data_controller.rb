class GraphDataController < ApplicationController
  
  def recent_temperatures
    @recent_temperatures = Rails.cache.fetch("v1/recent_temperatures", expires_in: 5.minutes) do
      SensorObservation.where( sensor_id: 1 ).where( "observed_at > ?", (Time.now.in_time_zone - 2.days).beginning_of_day ).order( observed_at: :asc ).collect{ |so| [so.observed_at, (so.value * (9.0/5.0) + 32.0).round(1)] }
    end
    
    # [{name: 'Temperature', data: @recent_temperatures, min: nil, max: nil, library: {borderWidth: 1, lineTension: 0.05, pointRadius: 0}}]
    
    render json: [{name: 'Temperature', data: @recent_temperatures, min: nil, max: nil, library: {borderWidth: 1, lineTension: 0.05, pointRadius: 0, scales: { xAxes: [{gridLines: { display: true }}]}}}]
  end
  
  def recent_highs_and_lows
    
    @recent_high_temperatures = Rails.cache.fetch("v1/recent_high_temperatures", expires_in: 5.minutes ) do
      SensorDailyAggregation.where( sensor_id: 1 ).where( "day > ?", 45.days.ago ).order( day: :asc ).collect{ |a| [a.day, a.maximum.to_f * (9.0/5.0) + 32.0] }
    end

    @recent_low_temperatures  = Rails.cache.fetch("v1/recent_low_temperatures", expires_in: 5.minutes ) do
      SensorDailyAggregation.where( sensor_id: 1 ).where( "day > ?", 45.days.ago ).order( day: :asc ).collect{ |a| [a.day, a.minimum.to_f * (9.0/5.0) + 32.0] }
    end
    
    @recent_average_temperatures  = Rails.cache.fetch("v1/recent_average_temperatures", expires_in: 5.minutes ) do
      SensorDailyAggregation.where( sensor_id: 1 ).where( "day > ?", 45.days.ago ).order( day: :asc ).collect{ |a| [a.day, a.average.to_f * (9.0/5.0) + 32.0] }
    end
    
    
    # [{name: 'High Temperature', data: @recent_high_temperatures, library: {lineTension: 0.25, pointRadius: 0, responsive: true, scales: { yAxes: [{ ticks:{ stepSize: 10 } }] }}}, {name: 'Low Temperature', data: @recent_low_temperatures, library: {lineTension: 0.25, pointRadius: 0}}]
    
    render json: [{name: 'High Temperature', data: @recent_high_temperatures, library: {lineTension: 0.25, pointRadius: 0, responsive: true, scales: { yAxes: [{ ticks:{ stepSize: 10 } }] }}}, {name: 'Low Temperature', data: @recent_low_temperatures, library: {lineTension: 0.25, pointRadius: 0}}, {name: 'Average Temperature', data: @recent_average_temperatures, library: {lineTension: 0.25, pointRadius: 0}}]
  end
  
  def recent_dewpoints
    @recent_dewpoints = Rails.cache.fetch("v1/recent_dewpoints", expires_in: 5.minutes) do
      SensorObservation.where( sensor_id: 4 ).where( "observed_at > ?", (Time.now.in_time_zone - 2.days).beginning_of_day ).order( observed_at: :asc ).collect{ |so| [so.observed_at, (so.value * (9.0/5.0) + 32.0).round(1)] }
    end
    
    # [{name: 'Temperature', data: @recent_temperatures, min: nil, max: nil, library: {borderWidth: 1, lineTension: 0.05, pointRadius: 0}}]
    
    render json: [{name: 'Dewpoint', data: @recent_dewpoints, min: nil, max: nil, library: {borderWidth: 1, lineTension: 0.05, pointRadius: 0, scales: { xAxes: [{gridLines: { display: true }}]}}}]
  end
  
  
  def highs_and_lows
    
    @range_start = params[:range_start]
    @range_end   = params[:range_end]

    @range_start ||= 45.days.ago
    @range_end   ||= Time.now
    
    @range = @range_start..@range_end
    
    @high_temperatures = SensorDailyAggregation.where( sensor_id: 1 ).where( day: @range ).order( day: :asc ).collect{ |a| [a.day, a.maximum.to_f * (9.0/5.0) + 32.0] }

    @low_temperatures  = SensorDailyAggregation.where( sensor_id: 1 ).where( day: @range ).order( day: :asc ).collect{ |a| [a.day, a.minimum.to_f * (9.0/5.0) + 32.0] }    
    
    render json: [{name: 'High Temperature', data: @high_temperatures, library: {lineTension: 0.25, pointRadius: 0, responsive: true, scales: { yAxes: [{ ticks:{ stepSize: 10 } }] }}}, {name: 'Low Temperature', data: @low_temperatures, library: {lineTension: 0.25, pointRadius: 0}}]
  end
  
  def compare_month_highs
    data = []
    
    if params[:month].present?
      start = Time.new( Time.now.in_time_zone.year, params[:month].to_i, 1, 12, 00 )
    else
      start = Time.now.in_time_zone
    end
    
    years_range.each do |n|
      range = (start - n.years).beginning_of_month..(start - n.years).end_of_month
      temperatures = SensorDailyAggregation.where( sensor_id: 1 ).where( day: range ).order( day: :asc ).collect{ |a| [a.day.strftime("%b %-d"), a.maximum.to_f * (9.0/5.0) + 32.0] }
      
      data << { name: "#{(Time.now.in_time_zone - n.years).year}", data: temperatures, library: {lineTension: 0.25, pointRadius: 0, responsive: true, scales: { yAxes: [{ ticks:{ stepSize: 10 } }] }}}
    end
    
    render json: data
  end
  
  def compare_month_lows
    data = []
    
    if params[:month].present?
      start = Time.new( Time.now.in_time_zone.year, params[:month].to_i, 1, 12, 00 )
    else
      start = Time.now.in_time_zone
    end
    
    years_range.each do |n|
      range = (start - n.years).beginning_of_month..(start - n.years).end_of_month
      temperatures = SensorDailyAggregation.where( sensor_id: 1 ).where( day: range ).order( day: :asc ).collect{ |a| [a.day.strftime("%b %-d"), a.minimum.to_f * (9.0/5.0) + 32.0] }
      
      data << { name: "#{(Time.now.in_time_zone - n.years).year}", data: temperatures, library: {lineTension: 0.25, pointRadius: 0, responsive: true, scales: { yAxes: [{ ticks:{ stepSize: 10 } }] }}}
    end
    
    render json: data
  end
  
  def years_range
    data_start_year = 2015
    
    number_of_years = Time.now.year - data_start_year
    
    (0..number_of_years)
  end
  
  
  
end
