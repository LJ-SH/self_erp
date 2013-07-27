class AddGroupIdToPartNumbers < ActiveRecord::Migration
  def change
  	add_column :part_numbers, :group_id, :integer, :null => true
  end
end
