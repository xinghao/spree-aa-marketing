module Spree
  module Admin

    class LandingPagesController < MarketingBaseController
    
      def index
        @objects = LandingPage.order("id desc").all
      end
      
      def load_object()
        @object.relative_url = params[object_name]["relative_url"]
        @object.description = params[object_name]["description"]
      end
      
    end

  end
end