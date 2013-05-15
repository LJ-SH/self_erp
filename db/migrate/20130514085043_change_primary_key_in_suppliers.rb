class ChangePrimaryKeyInSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :s_id, :primary_key
    remove_column :suppliers, :id
  end  	
end
