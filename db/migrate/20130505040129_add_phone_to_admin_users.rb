class AddPhoneToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :telephone, :string
  end
end
