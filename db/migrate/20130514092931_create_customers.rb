class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers, :primary_key=>:c_id do |t|
      t.integer :c_id, :null => false
      t.string  :name
      t.column  :status, :enum, :limit => COMPANY_STATUS_DEFINITION, :default => :company_active
      t.string  :comment
      t.timestamps
    end
  end
end
