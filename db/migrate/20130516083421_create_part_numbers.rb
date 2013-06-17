class CreatePartNumbers < ActiveRecord::Migration
  def change
    create_table :part_numbers do |t|
      t.string  :name
      t.string  :code, :limit => 17
      t.string  :old_code     
      t.string  :vendor_code
      t.column  :status, :enum, :limit => STATUS_DEFINITION, :default => STATUS_DEFINITION[0]     
      t.decimal :latest_price, :precision => 8, :scale => 2
      t.string  :prepared_by
      t.string  :approved_by
      t.integer :part_group_id
      t.integer :supplier_id, :null => false
      t.integer :component_category_id, :null => false      
      t.column  :created_at, :datetime
    end
  end
end
