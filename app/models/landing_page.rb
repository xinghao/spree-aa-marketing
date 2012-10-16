class LandingPage < ActiveRecord::Base
  default_scope where(:active => true)
  has_many :traffic_sources, :class_name => "TrafficSource"
  validates :relative_url, :presence => true
  LPID = "LPID"
  
  #
  #1. remove trailing / from end
  #2. replace "/" and "/feature" to featured product url
  #3. return landpage object(created if not exist)
  #
  def self.new_or_exist_landing_page(relative_uri)
    relative_uri = relative_uri.sub(/(\/)+$/,'') if !relative_uri.blank?
    if relative_uri.blank? || relative_uri.downcase == '/featured' 
      product = Spree::ProductGroup.getFeaturedProduct();
      relative_uri = "/products/#{product.permalink}"
    end
    lp = LandingPage.find_by_relative_url relative_uri
    if lp.nil?
      lp = LandingPage.new
      lp.relative_url = relative_uri
      lp.description =  relative_uri + " [Auto created]"
      lp.save
    end
    return lp
  end
  
end
