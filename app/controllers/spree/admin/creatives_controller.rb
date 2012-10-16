module Spree
  module Admin
    class CreativesController < MarketingBaseController
    
      def index
        @objects = Creative.order("id desc").all
      end
      
      def load_object()
        @object.external_id = params[object_name]["external_id"]     
      end
      
      
    end

  end
end