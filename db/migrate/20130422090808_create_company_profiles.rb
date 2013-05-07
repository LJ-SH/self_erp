class CreateCompanyProfiles < ActiveRecord::Migration
  def change
    create_table :company_profiles do |t|
      t.string :company_name
      t.string :company_addr
      t.string :postcode
      t.string :company_desc
      t.string :contact
      t.string :primary_phone
      t.string :secondary_phone
      t.string :distribution_list
      t.string :appendix_name
      t.string :appendix_link
      t.timestamps
    end
  end
end
