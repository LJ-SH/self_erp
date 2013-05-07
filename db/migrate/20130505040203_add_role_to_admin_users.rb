class AddRoleToAdminUsers < ActiveRecord::Migration
  def change
  	add_column :admin_users, :role, :enum, :limit => ROLE_DEFINITION, :default => :role_others
  end
end
