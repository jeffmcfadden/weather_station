class AddIndicesToSensorObservations < ActiveRecord::Migration[5.2]
  def change
    
    add_index :sensor_observations, [:sensor_id, :observed_at]
    add_index :sensor_observations, :observed_at

  end
end
