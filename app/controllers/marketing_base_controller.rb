class MarketingBaseController < Spree::Admin::BaseController
  respond_to :html

  def parent_data
    self.class.parent_data
  end

  def object_name
    controller_name.singularize
  end

  def model_class
    controller_name.classify.constantize
  end

  def model_name
    parent_data[:model_name]
  end

  def new
    @object = model_class.new
    respond_with(@object)
    
  end
  
  def edit
    @object = model_class.find params["id"]
    respond_with(@object)
  end
  
  def delete
    @object = model_class.find params["id"]
    @object.active = false
    if (@object.save)
      flash.notice = "deleted successfully"
    else
      flash.notice = "deleted failed"
    end
    redirect_to :action => :index         
  end
  
  def create
    @object = model_class.new
    load_object
    if (@object.save)
      redirect_to :action => :index
    else
      respond_with(@object)
    end     
  end
  
  def update
    @object = model_class.find params["id"]
    if @object.update_attributes(params[object_name])
      flash.notice = flash_message_for(@object, :successfully_updated)
      redirect_to :action => :index
    else
      respond_with(@object, :location => [:admin, @object])
    end
  
  end
  
end
