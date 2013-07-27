class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer  :item_id
      t.string   :item_type
      t.integer  :location_id
      t.string   :location_type
      t.integer  :quantity_of_in_manufacturing, :default => 0
      t.integer  :quantity_of_surplus, :default => 0
      t.decimal  :average_price, :precision => 8, :scale => 2, :default => 1
      t.datetime :updated_at
      #t.timestamps
    end
  end
end
