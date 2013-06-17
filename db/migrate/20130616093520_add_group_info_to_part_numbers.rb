class AddGroupInfoToPartNumbers < ActiveRecord::Migration
  def change
  	add_column :part_numbers, :replaceable, :boolean, :default => false
  	add_column :part_numbers, :preference, :integer
  end
end
