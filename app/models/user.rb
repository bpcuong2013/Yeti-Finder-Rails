class User < ActiveRecord::Base
  belongs_to :city
  has_many :finds, :dependent => :destroy
  attr_accessible :id, :city_id, :device_id, :name
end
