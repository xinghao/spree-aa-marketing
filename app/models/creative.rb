class Creative < ActiveRecord::Base
  default_scope where(:active => true)
  has_many :traffic_sources, :class_name => "TrafficSource"

  validates :name, :presence => true
    
  CID = "creativeId"
  
end
