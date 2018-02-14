class InvalidAPITokenError < StandardError 
end
  
class Api::ApplicationController < ApplicationController
  protect_from_forgery with: :null_session
  
  private
  
  def verify_api_token
    unless request.headers["Authorization"] == "Bearer #{ENV['API_TOKEN']}"
      raise InvalidAPITokenError, "API Token Invalid" 
    end
  end
  
end