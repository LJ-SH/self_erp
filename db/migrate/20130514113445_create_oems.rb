class CreateOems < ActiveRecord::Migration
  def change
    create_table :oems, :primary_key=>:o_id do |t|
      t.integer :o_id, :null => false
      t.string  :name
      t.column  :status, :enum, :limit => COMPANY_STATUS_DEFINITION, :default => :company_active
      t.string  :comment
      t.timestamps
    end
  end
end
