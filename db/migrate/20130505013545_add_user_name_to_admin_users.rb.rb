class AddUserNameToAdminUsers < ActiveRecord::Migration
  def up
  	add_column :admin_users, :user_name, :string
  	AdminUser.reset_column_information           #force all cached information reloaded on next request
  	AdminUser.find_by_email("admin@example.com").update_attribute(:user_name, "admin") 
  	add_index :admin_users, :user_name, :unique => true
  end

  def down
  	remove_index :admin_users, :user_name  	
    remove_column :admin_users, :user_name
  end
end
