class CreateBomParts < ActiveRecord::Migration
  def change
    create_table :bom_parts do |t|
      t.references :bom
      t.references :part_number
      t.integer :amount, :default => 1
      t.string  :location
      t.string  :comments
      t.timestamps
    end
  end
end