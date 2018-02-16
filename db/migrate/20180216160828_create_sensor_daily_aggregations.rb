class CreateSensorDailyAggregations < ActiveRecord::Migration[5.2]
  def change
    create_table :sensor_daily_aggregations do |t|
      t.references :sensor, foreign_key: true
      t.datetime :day
      t.float :minimum
      t.datetime :minimum_at
      t.float :maximum
      t.datetime :maximum_at
      t.float :average

      t.timestamps
    end
  end
end
