Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "marketing_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%= tab(:marketing, :marketing_campaigns, :landing_pages, :networks, :creatives, :traffic_sources, :url => '/admin/marketing/reports') %>",
                     :disabled => false)