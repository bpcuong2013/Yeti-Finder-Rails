module YetiFindingHelper
  RADIAN_PER_DEGREE = Math::PI / 180.0
  RADIUS_KM = 6378.14
  
  def convertFloat(val)
    if(val == nil)
      return 0
    end
    
    return val.to_f
  end
  
  def haversine(lat1, lng1, lat2, lng2)
    dlng = lng1 - lng2
    
    lat1_rad = lat1 * RADIAN_PER_DEGREE
    lat2_rad = lat2 * RADIAN_PER_DEGREE
    dlng_rad = dlng * RADIAN_PER_DEGREE
    dlat_rad = lat1_rad - lat2_rad
    
    a = power(Math::sin(dlat_rad/2), 2) + Math::cos(lat1_rad) * Math::cos(lat2_rad) * power(Math::sin(dlng_rad/2), 2)
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    
    return RADIUS_KM * c
  end
end
