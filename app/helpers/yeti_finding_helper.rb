module YetiFindingHelper
  def convertFloat(val)
    if(val == nil)
      return 0
    end
    
    return val.to_f
  end
end
