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
  
  # find all of yetis in range
  def findYetis
    longitude = convertFloat(params[:longitude])
    latitude = convertFloat(params[:latitude])
    user_id = params[:user_id]
    
    user = User.find_by_id(user_id)
    found_yeti_ids = user.finds.map { |m| m[:yeti_id] }
    
    available_yetis = Yeti.where("city_id = :city_id AND id NOT IN :yeti_ids", { city_id: user.city_id, yeti_ids: found_yeti_ids })
    in_range_yetis = []
    
    haversineHelper = HaversineHelper.new
    available_yetis.each do |yeti|
      if haversineHelper.distanceInMile(latitude, longitude, convertFloat(yeti.lat), convertFloat(yeti.long)) <= 5000 # compare values in miles
        in_range_yetis.push yeti
      end
    end
    
    respond_to do |format|
      format.json {
        render :json => { :success => true, :data => in_range_yetis }
      }
    end
  rescue Exception => ex
    logger.fatal "Exception in findYetis action: " + ex.message
    respond_to do |format|
      format.json {
        render :json => { :success => false, :msg => ex.message }
      }
    end
  end
  
  # Save yeti found
  def saveYetiFound
    user_id = params[:user_id]
    yeti_id = params[:yeti_id]
    
    yetiFound = Find.where("user_id = :user_id AND yeti_id = :yeti_id", { user_id: user_id, yeti_id: yeti_id })
    if yetiFound == nil
      yetiFound = Find.new
      yetiFound.user_id = user_id
      yetiFound.yeti_id = yeti_id
      
      yetiFound.save
    end
    
    respond_to do |format|
      format.json {
        render :json => { :success => true, :data => "Successfully saved" }
      }
    end
  rescue Exception => ex
    logger.fatal "Exception in saveYetiFound action: " + ex.message
    respond_to do |format|
      format.json {
        render :json => { :success => false, :msg => ex.message }
      }
    end
  end
  
  def getScoreboard
    user_id = params[:user_id]
  rescue Exception => ex
    logger.fatal "Exception in getScoreboard action: " + ex.message
    respond_to do |format|
      format.json {
        render :json => { :success => false, :msg => ex.message }
      }
    end
  end
end
