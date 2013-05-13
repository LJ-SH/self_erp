class CreateSupplyAgents < ActiveRecord::Migration
  def change
    create_table :supply_agents do |t|
      t.string  :name
      t.column  :status, :enum, :limit => COMPANY_STATUS_DEFINITION, :default => :company_active
      t.string  :comment
      t.timestamps
    end
  end
end
