class CreateMarketingCampaigns < ActiveRecord::Migration
  def change
    create_table :marketing_campaigns do |t|
      t.string :title
      t.integer :network_id
      t.boolean :active, :default => true
      t.timestamps
    end
    add_index :marketing_campaigns, [:title, :active]
    add_index :marketing_campaigns, [:network_id, :active]
  end
end
