class MarketingCampaign < ActiveRecord::Base
  default_scope where(:active => true)
  has_many :traffic_sources, :class_name => "TrafficSource"
  belongs_to :network, :class_name => "Network"
  
  validates :title, :presence => true
    
  MCID = "MCID"
end
