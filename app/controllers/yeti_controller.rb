class YetiController < ApplicationController
  def index
  end
  
  def listCities
    cities = City.all
    
    respond_to do |format|
      format.json {
        render :json => { :success => true, :data => cities }
      }
    end
  rescue Exception => ex
    logger.fatal "Exception in listCities action: " + ex.message
    respond_to do |format|
      format.json {
        render :json => { :success => false, :msg => ex.message }
      }
    end
  end
  
  def listNamedYetis
    city_id = params[:city_id]
    yetis = Yeti.where("city_id = :city_id AND is_anonymous = :is_anonymous", { city_id: city_id, is_anonymous: false })
    #yetis = Yeti.find_all_by_city_id(city_id)
    
    respond_to do |format|
      format.json {
        render :json => { :success => true, :data => yetis }
      }
    end
  rescue Exception => ex
    logger.fatal "Exception in listYetis action: " + ex.message
    respond_to do |format|
      format.json {
        render :json => { :success => false, :msg => ex.message }
      }
    end
  end
  
  def createNamedYeti
    longitude = params[:longitude]
    latitude = params[:latitude]
    city_id = params[:city_id]
    yeti_name = params[:yeti_name]
    yeti_desc = params[:yeti_desc]
    
    yeti = Yeti.new
    yeti.lat = latitude
    yeti.long = longitude
    yeti.name = yeti_name
    yeti.description = yeti_desc
    yeti.city_id = city_id
    yeti.is_anonymous = false
    
    yeti.save
    
    respond_to do |format|
      format.json {
        render :json => { :success => true, :data => "Successfully created named yeti" }
      }
    end
  rescue Exception => ex
    logger.fatal "Exception in createNamedYeti action: " + ex.message
    respond_to do |format|
      format.json {
        render :json => { :success => false, :msg => ex.message }
      }
    end
  end
  
  def deleteNamedYeti
    yeti_id = params[:yeti_id]
    yeti = Yeti.find(yeti_id)
    
    if (yeti != nil)
      yeti.finds.destroy_all
      yeti.destroy
    end
    
    respond_to do |format|
      format.json {
        render :json => { :success => true, :data => "Successfully deleted" }
      }
    end
  rescue Exception => ex
    logger.fatal "Exception in deleteNamedYeti action: " + ex.message
    respond_to do |format|
      format.json {
        render :json => { :success => false, :msg => ex.message }
      }
    end
  end
end
