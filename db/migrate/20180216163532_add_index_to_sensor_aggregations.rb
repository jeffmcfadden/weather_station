class AddIndexToSensorAggregations < ActiveRecord::Migration[5.2]
  def change
    add_index :sensor_daily_aggregations, [:sensor_id, :day]
  end
end
