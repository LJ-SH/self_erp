class ChangePartNumberStatusDefinition < ActiveRecord::Migration
  def up
  	change_column :part_numbers, :status, :enum, :limit => DEFAULT_STATUS_DEFINITION, :default => DEFAULT_STATUS_DEFINITION[0]
  end

  def down
  	change_column :part_numbers, :status, :enum, :limit => STATUS_DEFINITION, :default => STATUS_DEFINITION[0]
  end
end
