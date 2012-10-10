class CreateTrafficSources < ActiveRecord::Migration
  def change
    create_table :traffic_sources do |t|
       t.integer :order_id
       t.integer :user_id
       t.integer :marketing_campaign_id
       t.integer :landing_page_id
       t.string :keyword
       t.integer :creative_id
       t.string :referrer_url
       t.boolean :active, :default => true    
       t.timestamps
     end
     
     add_index :traffic_sources, [:updated_at, :active]
     add_index :traffic_sources, [:order_id, :active]
     add_index :traffic_sources, [:user_id, :active]
     add_index :traffic_sources, [:marketing_campaign_id, :landing_page_id, :active], :name => "traffic_sources_mcid_lp_active"
        
  end
end
