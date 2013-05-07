class RemoveAppendixNameFromCompanyProfiles < ActiveRecord::Migration
  def change
  	remove_column :company_profiles, :appendix_name
  end
end
