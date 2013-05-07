class AddPolymorphicInterfaceToCompanyProfiles < ActiveRecord::Migration
  def change
  	remove_column :company_profiles, :supplier_id
  	add_column :company_profiles, :company_id, :integer
  	add_column :company_profiles, :company_type, :string  	
  end
end
