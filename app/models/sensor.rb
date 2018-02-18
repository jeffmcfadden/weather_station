class Sensor < ApplicationRecord
  has_many :sensor_observations
  has_many :sensor_daily_aggregations 

  enum sensor_type: { temperature: 0, relative_humitity: 1, barometric_pressure: 2 }
  
  after_commit :update_latest_value_cache

  def latest_observation
    sensor_observations.order( observed_at: :desc ).limit(1).first
  end
  
  private
  
  def update_latest_value_cache
    latest_value             = latest_observation.value
    latest_value_observed_at = latest_observation.observed_at

    self.update_columns( latest_value: latest_value, latest_value_observed_at: latest_value_observed_at )
  end

end