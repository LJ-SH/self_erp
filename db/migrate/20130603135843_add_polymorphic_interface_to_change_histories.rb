class AddPolymorphicInterfaceToChangeHistories < ActiveRecord::Migration
  def change
  	add_column :change_histories, :trackable_obj_id, :integer
  	add_column :change_histories, :trackable_obj_type, :string  	
  end
end
