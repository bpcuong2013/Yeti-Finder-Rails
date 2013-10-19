require 'rubygems'
require 'clockwork'
require 'date'
require './config/boot'
require './config/environment'
require './app/workers/schedule_worker'

include Clockwork

#every(2.minutes, 'generateRandomYetisDaily.job') {
#  puts "Run 2 minutely job at " + Time.now.to_s
#  cities = City.all
#  FoursquareHelper.new.selectSearchTerm()
#  
#  puts "Total daily schedule = " + cities.size.to_s
#  puts "New search term = " + FoursquareHelper.SELECTED_SEARCH_TERM
#  
#  if (cities.size > 0)
#    cities.each do |city|
#      puts city.name
#      ScheduleWorker.perform_async(city.id, city.name)
#    end
#  end
#}

every(1.day, 'generateRandomYetisDaily.job', :at => '23:59') {
  puts "Run daily job at " + Time.now.to_s
  cities = City.all
  FoursquareHelper.new.selectSearchTerm()
  
  puts "Total daily schedule = " + cities.size.to_s
  puts "New search term = " + FoursquareHelper.SELECTED_SEARCH_TERM
  
  if (cities.size > 0)
    cities.each do |city|
      ScheduleWorker.perform_async(city.id, city.name)
    end
  end
}
