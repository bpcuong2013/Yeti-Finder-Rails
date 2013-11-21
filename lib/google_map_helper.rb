require 'rest-client'
require 'crack/xml' # for just xml

class GoogleMapHelper
  GOOGLE_API_URL = "http://maps.googleapis.com/maps/api/geocode/xml?sensor=false&latlng="
  
  def getCity(latitude, longitude)
    coor = latitude.to_s + "," + longitude.to_s
    response = RestClient.get(GOOGLE_API_URL + coor)
    
    parsed_response = Crack::XML.parse(response)
    
    error_code = parsed_response["GeocodeResponse"]["status"]
    
    # Refer https://developers.google.com/maps/documentation/javascript/geocoding?hl=vi to extract city
    if error_code.eql? "OK"
      parsed_response["GeocodeResponse"]["result"].each do |result|
        if result["type"].eql? "postal_town"
          return result["formatted_address"]
          #address_components = result["address_component"]
          #address_components.each do |component|
          #  if (component["type"].eql? "postal_town")
          #    return component["long_name"]
          #  end
          #end
        end
      end
      
      parsed_response["GeocodeResponse"]["result"].each do |result|
        types = result["type"]
        if (types.is_a? Array)
          if ((types.include? "locality") || (types.include? "sublocality"))
            address_components = result["address_component"]
            address_components.each do |component|
              localTypes = component["type"]
              if (localTypes.eql? "locality")
                return component["long_name"]
              end
              
              if ((localTypes.is_a? Array) && (localTypes.include? "locality"))
                return component["long_name"]
              end
            end
          end
        end
      end
      
      raise "City not found"
    else
      raise error_code
    end
  end
end