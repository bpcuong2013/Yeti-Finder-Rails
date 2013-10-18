class YetiFindingController < ApplicationController
  include YetiFindingHelper
  
  def index
  end
  
  def detectDevice
    longitude = params[:longitude]
    latitude = params[:latitude]
    device_id = params[:device_id]

    # retrieve city name from Google Maps using latitude and longitude
    city_name = GoogleMapHelper.new.getCity(latitude, longitude)
    city = City.find_by_name(city_name)
    
    if city == nil
      city = City.new :name => city_name
      city.save      
    end
    
    returnedInfo = { }
    returnedInfo["city_name"] = city_name
    returnedInfo["user_id"] = ""
    
    # determine whehther deviceId is exiting in User table
    user = User.find_by_device_id(device_id)
    if user != nil
      if user.city_id != city.id
        user.city_id = city.id
        user.save
      end
      
      returnedInfo["user_id"] = user.id
    end
    
    respond_to do |format|
      format.json {
        render :json => { :success => true, :data => returnedInfo }
      }
    end
  rescue Exception => ex
    logger.fatal "Exception in detectDevice action: " + ex.message
    respond_to do |format|
      format.json {
        render :json => { :success => false, :msg => ex.message }
      }
    end
  end
  
  def joinSystem
    device_id = params[:device_id]
    city_name = params[:city_name]
    user_name = params[:user_name]
    
    city = City.find_by_name(city_name)
    user = User.new
    user.city_id = city.id
    user.device_id = device_id
    user.name = user_name
    
    user.save
    
    respond_to do |format|
      format.json {
        render :json => { :success => true, :data => user.id }
      }
    end
  rescue Exception => ex
    logger.fatal "Exception in joinSystem action: " + ex.message
    respond_to do |format|
      format.json {
        render :json => { :success => false, :msg => ex.message }
      }
    end
  end
  
  def findYetis
    
  end
end
