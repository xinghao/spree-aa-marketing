module Spree
  module Admin
    class MarketingReportsController < MarketingBaseController      
      before_filter :load_date_range, :only => [:index, :export_to_csv]
      before_filter :load_data, :only => [:index, :export_to_csv]
      
      def export_to_csv
      end
      
      def index
        @search_url = "/admin/marketing/reports";
#        @objects = Creative.order("id desc").all
         @preview_count = 5;
         
         
      end
      
      def load_data
        #Rails.logger.info("1NMNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN")
        @networks = Network.order("id desc").all
        @reports = TrafficSource.report_overview_data(@start_from, @end_to)
        #Rails.logger.info("2NMNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN")
        #aa = network.hash.sort_by {|k,v| k}.reverse       
        # @reports.each_pair do |key, vale|
        #   Rails.logger.info("NMNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN: #{key}: #{vale}")
        # end       
      end ## funcation end
            
      
    end #### class end

  end
end