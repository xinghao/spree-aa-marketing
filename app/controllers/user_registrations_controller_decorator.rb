Spree::UserRegistrationsController.class_eval do

  def create_traffic_source(user_id)
    begin
      ts = TrafficSource.new_traffic_source(cookies, user_id, request.env)
      if !ts.nil?
        cookies[TrafficSource::TSID] = {
          :value => ts.id,
          :expires => 3.months.from_now,
          :domain => :all, 
          :httponly => false
        }
      end
    rescue => ex
      Rails.logger.info("create traffic source failed #{ex}")
    end    
    
  end  
               
end