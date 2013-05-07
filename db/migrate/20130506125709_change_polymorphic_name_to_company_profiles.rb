class ChangePolymorphicNameToCompanyProfiles < ActiveRecord::Migration
  def change
  	rename_column(:company_profiles, :company_type, :companyable_type)
  	rename_column(:company_profiles, :company_id, :companyable_id)  	
  end
end
