class CreateLandingPages < ActiveRecord::Migration
  def change
    create_table :landing_pages do |t|
      t.string :relative_url
      t.string :description
      t.boolean :active, :default => true      
      t.timestamps
    end
    add_index :landing_pages, [:relative_url, :active]
  end
end
