# Source of this class is from http://www.esawdust.com/blog/gps/files/HaversineFormulaInRuby.html 

class HaversineHelper
  RADIAN_PER_DEGREE = Math::PI / 180.0
  RADIUS_MILE = 3956    # radius of the great circle in miles
  RADIUS_KM = 6371      # radius in kilometers ... some algorithms use 6367
  RADIUS_FEET = RADIUS_MILE * 5282 # radius in feet
  RADIUS_METER = RADIUS_KM * 1000 # radius in meters
  
  def distanceInKm(lat1, lng1, lat2, lng2)
    return RADIUS_KM * getCoefficient(lat1, lng1, lat2, lng2)
  end
  
  def distanceInMile(lat1, lng1, lat2, lng2)
    return RADIUS_MILE * getCoefficient(lat1, lng1, lat2, lng2)
  end
  
  def distanceInFeet(lat1, lng1, lat2, lng2)
    return RADIUS_FEET * getCoefficient(lat1, lng1, lat2, lng2)
  end
  
  def distanceInMeter(lat1, lng1, lat2, lng2)
    return RADIUS_METER * getCoefficient(lat1, lng1, lat2, lng2)
  end
  
  private
  def getCoefficient(lat1, lng1, lat2, lng2)
    dlng = lng1 - lng2
    
    lat1_rad = lat1 * RADIAN_PER_DEGREE
    lat2_rad = lat2 * RADIAN_PER_DEGREE
    dlng_rad = dlng * RADIAN_PER_DEGREE
    dlat_rad = lat1_rad - lat2_rad
    
    a = power(Math::sin(dlat_rad/2), 2) + Math::cos(lat1_rad) * Math::cos(lat2_rad) * power(Math::sin(dlng_rad/2), 2)
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    
    return c
  end
  
  def power(num, pow)
    num ** pow
  end
end