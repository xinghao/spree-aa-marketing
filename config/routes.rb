Spree::Core::Engine.routes.draw do

  match 'admin/marketing/reports' => 'Admin::MarketingReports#index'
    
  namespace :admin do  
    resources :traffic_sources do
      member do
        get 'delete'
      end      
    end
    
    resources :networks do
      member do
        get 'delete'
      end      
    end
    
    resources :creatives do
      member do
        get 'delete'
      end      
    end
    
    resources :marketing_campaigns do
      member do
        get 'delete'
      end
    end 
    resources :landing_pages do
      member do
        get 'delete'
      end      
    end
    
  end
  # Add your extension routes here
end
