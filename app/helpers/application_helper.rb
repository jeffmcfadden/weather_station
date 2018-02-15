module ApplicationHelper

  def formatted_temperature(t)
    f = (t * (9.0/5.0) + 32.0).round(1)
    "#{f}°F"
  end

end
