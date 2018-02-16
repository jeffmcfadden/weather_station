class HomeController < ApplicationController
  def index
    @recent_temperatures = Rails.cache.fetch("v1/recent_temperatures", expires_in: 5.minutes) do
      SensorObservation.where( sensor_id: 1 ).where( "observed_at > ?", Time.now.in_time_zone - 3.days ).collect{ |so| [so.observed_at, (so.value * (9.0/5.0) + 32.0).round(1)] }
    end

    @recent_high_temperatures = Rails.cache.fetch("v1/recent_high_temperatures", expires_in: 5.minutes ) do
      SensorDailyAggregation.where( sensor_id: 1 ).where( "day > ?", 90.days.ago ).collect{ |a| [a.day, a.maximum.to_f * (9.0/5.0) + 32.0] }
    end

    @recent_low_temperatures  = Rails.cache.fetch("v1/recent_low_temperatures", expires_in: 5.minutes ) do
      SensorDailyAggregation.where( sensor_id: 1 ).where( "day > ?", 90.days.ago ).collect{ |a| [a.day, a.minimum.to_f * (9.0/5.0) + 32.0] }
    end

  end
end
