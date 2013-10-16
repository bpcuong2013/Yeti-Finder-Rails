class YetiFindingController < ApplicationController
  include YetiFindingHelper
  
  def index
  end
  
  def detectDevice
    longitude = params[:longitude]
    latitude = params[:latitude]
    deviceId = params[:deviceId]
  end
end
