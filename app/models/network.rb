class Network < ActiveRecord::Base
  default_scope where(:active => true)
  has_many :marketing_campaigns, :class_name => "MarketingCampaign"
  has_many :traffic_sources, :class_name => "TrafficSource", :through => :marketing_campaigns
  validates :name, :presence => true
end
