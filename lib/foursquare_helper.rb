require 'json'
require 'rest-client'
require 'uri'

class FoursquareHelper
  CLIENT_ID = "LDF11AWSYIB4CHS1GAT2QMYUCHVEVQEPQ20T5YZOJI4SYE1P"
  CLIENT_SECRET = "SUWYX0S12VVFNWXHRWIGAHT32X0H3DXKTCVSMEQUCHIB0YZB"
  FOURSQUARE_API_URL = "https://api.foursquare.com/v2/venues/search/?"
  SEARCH_TERMS = ["donuts", "pizza", "parks"]
  @@SELECTED_SEARCH_TERM = "" # class variable
  
  def self.SELECTED_SEARCH_TERM
    @@SELECTED_SEARCH_TERM
  end
  
  def selectSearchTerm
    random = rand(0..2)
    @@SELECTED_SEARCH_TERM = SEARCH_TERMS[random]
  end
  
  def searchVenues(city_name, search_term)
    query_string = URI.encode("client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&near=#{city_name}&query=#{search_term}&limit=10")
    response = RestClient.get(FOURSQUARE_API_URL + query_string)
    
    parsed_response = JSON.parse(response)
    yetis = []
    
    if parsed_response["meta"]["code"].eql? 200
      parsed_response["response"]["groups"].each do |group|        
        group["items"].each do |item|
          yeti = {}
          yeti["name"] = item["name"]
          yeti["latitude"] = item["location"]["lat"]
          yeti["longitude"] = item["location"]["lng"]
          
          yetis.push yeti
        end
        
        return yetis
      end
    else
      raise parsed_response["meta"]["errorDetail"]
    end
    
    return yetis
  end
end