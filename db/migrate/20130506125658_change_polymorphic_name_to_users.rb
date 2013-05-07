class ChangePolymorphicNameToUsers < ActiveRecord::Migration
  def change
  	rename_column(:users, :company_type, :companyable_type)
  	rename_column(:users, :company_id, :companyable_id)
  end
end
