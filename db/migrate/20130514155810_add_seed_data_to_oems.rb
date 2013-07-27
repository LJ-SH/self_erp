class AddSeedDataToOems < ActiveRecord::Migration
  def migrate(direction)
    super
    if direction == :up then
      CompanyProfile.where(:companyable_type => 'Oem').delete_all
      User.where(:companyable_type => 'Oem').delete_all
      Oem.delete_all
	    Oem.create!(:name=>'suzhou', :o_id=>1, :company_profile_attributes => { :company_name => '苏州'}, )
	    Oem.create!(:name=>'shengmeide', :o_id=>2, :company_profile_attributes => { :company_name => '胜美德'}, )
	    Oem.create!(:name=>'ceshi', :o_id=>3, :company_profile_attributes => { :company_name => '测试'}, )
	    Oem.create!(:name=>'qihang', :o_id=>4, :company_profile_attributes => { :company_name => '旗瀚'}, )   
    end
  end
end
