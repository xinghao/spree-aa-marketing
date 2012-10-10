class NetworksController < MarketingBaseController
  def index
    @objects = Network.order("id desc").all    
  end

  def load_object()
    @object.name = params[object_name]["name"]     
  end
  
  
end
