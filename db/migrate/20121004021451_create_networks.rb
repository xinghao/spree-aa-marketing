class CreateNetworks < ActiveRecord::Migration
  def change
    create_table :networks do |t|
      t.string :name
      t.boolean :active, :default => true
      t.timestamps
    end
  end
end
