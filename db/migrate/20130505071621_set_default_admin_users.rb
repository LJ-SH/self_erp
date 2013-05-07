class SetDefaultAdminUsers < ActiveRecord::Migration
  def up
  	AdminUser.reset_column_information
  	AdminUser.find_by_email("admin@example.com").update_attributes(:role => "role_super", :email => "super@example.com", :user_name => "super")
  end

  def down
  end
end
