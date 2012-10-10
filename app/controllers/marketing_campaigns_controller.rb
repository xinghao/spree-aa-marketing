class MarketingCampaignsController < MarketingBaseController
  #respond_to :html
  
  # def new
  #   @object = model_class.new
  #   respond_with(@object)
  #   
  # end
  # 
  # def edit
  #   @object = model_class.find params["id"]
  #   respond_with(@object)
  # end
  # 
  # def create
  #   @object = model_class.new
  #   load_object
  #   if (@object.save)
  #     render "index"
  #   else
  #     respond_with(@object)
  #   end     
  # end
  # 
  # def update
  #   @object = model_class.find params["id"]
  #   if @object.update_attributes(params[object_name])
  #     flash.notice = flash_message_for(@object, :successfully_updated)
  #     redirect_to :action => :index
  #   else
  #     respond_with(@object, :location => [:admin, @object])
  #   end
  # 
  # end
  
  def load_object()
    @object.title = params[object_name]["title"]
    @object.network_id = params[object_name]["network_id"]     
  end
  
  def index
    @networks = Network.order("id desc").all
    @campaigns = Hash.new
    @networks.each do |network|
      @campaigns[network.id] = MarketingCampaign.where("network_id = ?", network.id).order("id desc").all
    end
  end
  
end
