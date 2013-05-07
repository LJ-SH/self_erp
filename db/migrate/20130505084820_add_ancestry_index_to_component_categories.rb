class AddAncestryIndexToComponentCategories < ActiveRecord::Migration
  def change
    add_column :component_categories, :ancestry, :string
    add_column :component_categories, :ancestry_depth, :integer, :default => 0  	
  	add_index :component_categories, :ancestry
  end
end
