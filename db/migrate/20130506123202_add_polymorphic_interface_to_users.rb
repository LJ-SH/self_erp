class AddPolymorphicInterfaceToUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :supplier_id
  	add_column :users, :company_id, :integer
  	add_column :users, :company_type, :string
  end
end
