class Sensor < ApplicationRecord
  has_many :sensor_observations

  enum sensor_type: { temperature: 0, relative_humitity: 1, barometric_pressure: 2 }

  def latest_observation
    sensor_observations.order( observed_at: :desc ).limit(1).first
  end

end