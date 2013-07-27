class RemovePartGroupIdFromPartNumbers < ActiveRecord::Migration
  def up
  	remove_column :part_numbers, :part_group_id
  end

  def down
  	add_column :part_numbers, :part_group_id, :integer
  end
end
