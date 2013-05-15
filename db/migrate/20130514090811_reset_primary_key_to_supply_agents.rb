class ResetPrimaryKeyToSupplyAgents < ActiveRecord::Migration
  def change
  	drop_table :supply_agents
    create_table :supply_agents, :primary_key=>:sa_id do |t|
      t.integer :sa_id, :null => false
      t.string  :name
      t.column  :status, :enum, :limit => COMPANY_STATUS_DEFINITION, :default => :company_active
      t.string  :comment
      t.timestamps
    end  	
  end
end
