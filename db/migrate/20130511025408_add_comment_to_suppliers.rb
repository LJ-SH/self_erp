class AddCommentToSuppliers < ActiveRecord::Migration
  def change
  	add_column :suppliers, :comment, :string
  end
end
