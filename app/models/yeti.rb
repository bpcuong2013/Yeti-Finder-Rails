class Yeti < ActiveRecord::Base
  belongs_to :city
  has_many :finds, :dependent => :destroy
  attr_accessible :id, :city_id, :lat, :long, :name, :description, :is_anonymous
end
