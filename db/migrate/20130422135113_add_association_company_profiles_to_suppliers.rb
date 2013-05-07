class AddAssociationCompanyProfilesToSuppliers < ActiveRecord::Migration
  def change
  	add_column :company_profiles, :supplier_id, :integer
  end
end
