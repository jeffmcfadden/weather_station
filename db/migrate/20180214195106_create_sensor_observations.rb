class CreateSensorObservations < ActiveRecord::Migration[5.2]
  def change
    create_table :sensor_observations do |t|
      t.references :sensor, foreign_key: true
      t.float :value
      t.datetime :observed_at

      t.timestamps
    end
  end
end
