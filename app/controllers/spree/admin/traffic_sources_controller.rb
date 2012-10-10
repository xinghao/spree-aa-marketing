module Spree
  module Admin

    class TrafficSourcesController < MarketingBaseController
      def index
        @objects = TrafficSource.includes(:order, :user, :creative, :landing_page, :marketing_campaign).order("updated_at desc").page(1).per(100)
      end  
    end

  end
end