class TrafficSource < ActiveRecord::Base
  default_scope where(:active => true)
  belongs_to :order, :class_name => "Spree::Order"
  belongs_to :user, :class_name => "Spree::User"
  belongs_to :marketing_campaign, :class_name => "MarketingCampaign"
  belongs_to :landing_page, :class_name => "LandingPage"
  belongs_to :creative, :class_name => "Creative"
  has_one :network, :class_name => "Network", :through => :marketing_campaign
  has_many :inventory_units, :class_name => "Spree::InventoryUnit",  :through => :order
  
  TSID = "tsid"
  KEYWORD = "keyword"
  REFERRER_URL = "referrer_url"
  MATCH_TYPE = "matchtype"
  
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
      creative = Creative.new_or_exist_creative(cookies[Creative::CID].to_s)      
      ts.creative = creative if !creative.nil?
    end      
    
    if !cookies[TrafficSource::KEYWORD].to_s.blank?
      ts.keyword = cookies[TrafficSource::KEYWORD].to_s
    end
    
    if !cookies[TrafficSource::MATCH_TYPE].to_s.blank?
      ts.match_type = cookies[TrafficSource::MATCH_TYPE].to_s
    end      

    
    if !cookies[TrafficSource::REFERRER_URL].to_s.blank?
      ts.referrer_url = cookies[TrafficSource::REFERRER_URL].to_s
    elsif (env['HTTP_REFERER'])
      ts.referrer_url = env['HTTP_REFERER']
    end      
    
    ts.save
    return ts    
  end
  
  
  def self.build_report_overview_structure(ret_hash, lead)
    if ret_hash.has_key?(lead.network_id.to_i)
      network_entry = ret_hash[lead.network_id.to_i] 
    else
      ret_hash[lead.network_id.to_i] = Reports::NetworkEntry.new
      network_entry   = ret_hash[lead.network_id.to_i]
      network_entry.id = lead.network_id.to_i
      network_entry.hash = Hash.new
      
    end
             
    if !network_entry.hash.has_key?(lead.marketing_campaign_id.to_i)
      network_entry.hash[lead.marketing_campaign_id.to_i] = Reports::MarketingCampaignEntry.new 
      network_entry.hash[lead.marketing_campaign_id.to_i].id = lead.marketing_campaign_id.to_i
      network_entry.hash[lead.marketing_campaign_id.to_i].hash = Hash.new
    end
    
    if !network_entry.hash[lead.marketing_campaign_id.to_i].hash.has_key?(lead.landing_page_id.to_i)
      network_entry.hash[lead.marketing_campaign_id.to_i].hash[lead.landing_page_id.to_i] = Reports::LandingPageEntry.new 
      network_entry.hash[lead.marketing_campaign_id.to_i].hash[lead.landing_page_id.to_i].id = lead.landing_page_id.to_i
      network_entry.hash[lead.marketing_campaign_id.to_i].hash[lead.landing_page_id.to_i].hash = Hash.new
    end           
    return ret_hash
  end
  

  def self.report_overview_data()
    
    ret_hash = Hash.new
                                
    #@reports[network.id] = TrafficSource.select("count(traffic_sources.id) as leads, spree_inventory_units.variant_id as variant_id, count(spree_inventory_units.id) as product_amount").joins({:order => :inventory_units}, :landing_page).group("landing_page_id, spree_inventory_units.variant_id")
    details = TrafficSource.select("network_id, marketing_campaign_id, landing_page_id, variant_id, count(traffic_sources.id) as orders_amount, count(spree_inventory_units.id) as product_amount").joins(:inventory_units, :landing_page, :marketing_campaign).group("network_id, marketing_campaign_id, landing_page_id, spree_inventory_units.variant_id")
    leads = TrafficSource.select("network_id, marketing_campaign_id, landing_page_id, count(traffic_sources.id) as leads").joins(:marketing_campaign).group("network_id, marketing_campaign_id, landing_page_id")
    
    Rails.logger.info("1NMNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN")
    
    # generate leads
    leads.each do |lead| 
      Rails.logger.info("NMNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN: #{lead.network_id}")
      ret_hash = build_report_overview_structure(ret_hash, lead)
      ret_hash[lead.network_id.to_i].hash[lead.marketing_campaign_id.to_i].hash[lead.landing_page_id.to_i].leads = lead.leads
    end  
    
    
    details.each do |detail|
      ret_hash = build_report_overview_structure(ret_hash, detail)
            
      land_page_entry = ret_hash[detail.network_id.to_i].hash[detail.marketing_campaign_id.to_i].hash[detail.landing_page_id.to_i]

      land_page_entry.hash[detail.variant_id.to_i] = {:order_amount => detail.orders_amount, :product_amount => detail.product_amount}      
    end
       
    return ret_hash    
  end
end
