class TrafficSource < ActiveRecord::Base
  default_scope where(:active => true)
  belongs_to :order, :class_name => "Spree::Order"
  belongs_to :user, :class_name => "Spree::User"
  belongs_to :marketing_campaign, :class_name => "MarketingCampaign"
  belongs_to :landing_page, :class_name => "LandingPage"
  belongs_to :creative, :class_name => "Creative"
  has_one :network, :class_name => "Network", :through => :marketing_campaign

  TSID = "tsid"
  KEYWORD = "Keyword"
  REFERRER_URL = "referrer_url"
  
  def self.update_traffic_source_with_order(cookies, order, env)
    ts = nil
    # new user coming from promotion
    if !cookies[TrafficSource::TSID].to_s.blank?
      tsid = cookies[TrafficSource::TSID].to_s
      ts = TrafficSource.find tsid
    else #existing user coming to us directly or existing user coming from promotion
      ts = new_traffic_source(cookies, order.user.id, env)
    end
    
    ts.order = order
    ts.save
    return ts
    
  end
  
  # if marketing id in cookies then using cookie info else use web compaign 
  def self.new_traffic_source(cookies, user_id, env)
    ts = TrafficSource.new
    
    ts.user_id = user_id
    
    ts.marketing_campaign_id = 1 # default is website

    if !cookies[MarketingCampaign::MCID].to_s.blank?
      ts.marketing_campaign_id = cookies[MarketingCampaign::MCID].to_s      
    end        

    if !cookies[LandingPage::LPID].to_s.blank?
      ts.landing_page_id = cookies[LandingPage::LPID].to_s
    else
      lp = LandingPage.new_or_exist_landing_page(env['REQUEST_PATH'])      
      ts.landing_page = lp;      
    end      
    
    if !cookies[Creative::CID].to_s.blank?
      ts.creative_id = cookies[Creative::CID].to_s
    end      
    
    if !cookies[TrafficSource::KEYWORD].to_s.blank?
      ts.keyword = cookies[TrafficSource::KEYWORD].to_s
    end      
    
    if !cookies[TrafficSource::REFERRER_URL].to_s.blank?
      ts.referrer_url = cookies[TrafficSource::REFERRER_URL].to_s
    elsif (env['HTTP_REFERER'])
      ts.referrer_url = env['HTTP_REFERER']
    end      
    
    ts.save
    return ts    
  end

end
