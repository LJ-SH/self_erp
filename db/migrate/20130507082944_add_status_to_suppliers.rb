class AddStatusToSuppliers < ActiveRecord::Migration
  def change
  	add_column :suppliers, :status, :enum, :limit => COMPANY_STATUS_DEFINITION, :default => :company_active
  end
end
