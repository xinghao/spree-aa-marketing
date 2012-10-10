class CreateCreatives < ActiveRecord::Migration
  def change
    create_table :creatives do |t|
      t.string :name
      t.boolean :active, :default => true      
      t.timestamps
    end
  end
end
