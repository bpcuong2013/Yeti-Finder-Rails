class AppHelper
  def deleteOldYetis(city_id)
    yetis = Yeti.find_all_by_city_id(city_id)
    deleted_yeti_ids = Array.new
    
    if (yetis.size > 0)
      yetis.each do |yeti|
        count = Find.where("yeti_id" => yeti.id).count(1)
        if (count < 1)
          deleted_yeti_ids.push yeti.id
        end
      end
      
      if (deleted_yeti_ids.size > 0)
        Yeti.where("id IN (:ids)", { ids: deleted_yeti_ids }).destroy_all
      end
    end
  end
  
  def createNewYetis(city_id, city_name, search_term)
    yetis = FoursquareHelper.new.searchVenues(city_name, search_term)
    
    yetis.each do |yeti|
      dbYeti = Yeti.new
      dbYeti.city_id = city_id
      dbYeti.lat = yeti["latitude"]
      dbYeti.long = yeti["longitude"]
      dbYeti.name = yeti["name"]
      dbYeti.is_anonymous = true
      
      dbYeti.save
    end
  end
end