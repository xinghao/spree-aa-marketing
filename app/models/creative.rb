class Creative < ActiveRecord::Base
  default_scope where(:active => true)
  has_many :traffic_sources, :class_name => "TrafficSource"

  validates :external_id, :presence => true
    
  CID = "creative"
  
  def self.new_or_exist_creative(external_id)
    return nil if external_id.blank?
    creative = Creative.find_by_external_id external_id
    
    if creative.nil?
      creative = Creative.new
      creative.external_id =  external_id + " [Auto created]"
      creative.save
    end
    
    return creative
  end
  
end
