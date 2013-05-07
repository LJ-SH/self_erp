class AddAssociationUsersToSuppliers < ActiveRecord::Migration
  def change
  	add_column :users, :supplier_id, :integer
  end
end
