module Spree
  module Admin
    class CreativesController < MarketingBaseController
    
      def index
        @objects = Creative.order("id desc").all
      end
      
      def load_object()
        @object.name = params[object_name]["name"]     
      end
      
      
    end

  end
end