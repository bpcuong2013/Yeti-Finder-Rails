class Find < ActiveRecord::Base
  belongs_to :user
  belongs_to :yeti
  attr_accessible :id, :user_id, :yeti_id
end
