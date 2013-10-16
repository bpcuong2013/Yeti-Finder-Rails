class City < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  has_many :yetis, :dependent => :destroy
  attr_accessible :id, :name
end
