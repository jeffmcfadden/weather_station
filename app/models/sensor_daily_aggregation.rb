class SensorDailyAggregation < ApplicationRecord
  belongs_to :sensor

  def self.update_aggregation_for_sensor(s, day: Time.now)
    raise 'SensorRequired for upsert_for_sensor' if s.nil?
    raise 'Day required for upsert_for_sensor'   if day.nil?
    
    day   = day.in_time_zone
    range = day.beginning_of_day..day.end_of_day
    
    aggregation = SensorDailyAggregation.where( sensor: s, day: range ).limit(1).first
    
    if aggregation.nil?
      aggregation = SensorDailyAggregation.new sensor:s, day: day.noon
    end
      
    minimum_record = s.sensor_observations.where( observed_at: range ).order( value: :asc ).limit(1).first
    maximum_record = s.sensor_observations.where( observed_at: range ).order( value: :desc ).limit(1).first
      
    aggregation.minimum    = minimum_record&.value
    aggregation.minimum_at = minimum_record&.observed_at

    aggregation.maximum    = maximum_record&.value
    aggregation.maximum_at = maximum_record&.observed_at

    aggregation.average = s.sensor_observations.where( observed_at: range ).average(:value)
      
    aggregation.save
  end

end