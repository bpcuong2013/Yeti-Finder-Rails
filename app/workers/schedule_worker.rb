require 'logger'

class ScheduleWorker
  include Sidekiq::Worker
  
  def perform(city_id, city_name)
    appHelper = AppHelper.new
    appHelper.deleteOldYetis(city_id)
    appHelper.createNewYetis(city_id, city_name, FoursquareHelper.SELECTED_SEARCH_TERM)
  rescue Exception => ex
    logger.error "=============Run city id = " + city_id.to_s + ", " + city_name + " failed=============="
    logger.error "Exception in when run schedule: " + ex.message
    logger.error ex.backtrace.join("\n")
  end
end