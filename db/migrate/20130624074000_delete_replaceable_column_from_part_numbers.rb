class DeleteReplaceableColumnFromPartNumbers < ActiveRecord::Migration
  def change
  	remove_column :part_numbers, :replaceable
  end
end
