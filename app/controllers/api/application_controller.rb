class Api::ApplicationController < ApplicationController
  protect_from_forgery with: :null_session
  
  class InvalidAPITokenError < StandardError;
  
  private
  
  def verify_api_token
    raise InvalidAPITokenError, "API Token Invalid" unless request.headers["Authorization"] == "Bearer #{ENV['API_TOKEN']}"
  end
  
end
