Spree::User.class_eval do
  has_many :traffic_sources, :class_name => "TrafficSource"
end