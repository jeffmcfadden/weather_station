class SensorObservation < ApplicationRecord
  belongs_to :sensor

  after_commit :update_aggregation
  
  private
  
  def update_aggregation
    SensorDailyAggregation.update_aggregation_for_sensor( sensor, day: observed_at )
  end

end
