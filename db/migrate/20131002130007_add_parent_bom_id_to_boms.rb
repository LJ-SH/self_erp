class AddParentBomIdToBoms < ActiveRecord::Migration
  def change
    add_column :boms, :parent_bom_id, :integer
  end
end
