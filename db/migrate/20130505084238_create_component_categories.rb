class CreateComponentCategories < ActiveRecord::Migration
  def change
    create_table :component_categories do |t|
      t.string  :name
      t.string  :comment
      t.string  :code      
      t.string  :updated_by_email 
      t.timestamps
    end
  end
end
