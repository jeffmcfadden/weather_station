class Sensor < ApplicationRecord
  has_many :sensor_observations

  enum sensor_type: { temperature: 0, relative_humitity: 1, barometric_pressure: 2 }

end