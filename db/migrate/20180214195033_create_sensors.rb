class CreateSensors < ActiveRecord::Migration[5.2]
  def change
    create_table :sensors do |t|
      t.string :name
      t.integer :sensor_type
      t.float :latest_value
      t.datetime :latest_value_observed_at
      t.text :sensor_settings

      t.timestamps
    end
  end
end
