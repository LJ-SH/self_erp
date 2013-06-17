class CompanyProfile < ActiveRecord::Base
  attr_accessible :company_name,:company_addr, :postcode, :company_desc, :contact, :primary_phone, :secondary_phone,
                  :distribution_list, :appendix_name, :appendix, :remove_appendix

  belongs_to :companyable, :polymorphic => true, :inverse_of => :company_profile

  mount_uploader :appendix, AppendixUploader

  validates_presence_of :company_name
  validates_uniqueness_of :company_name, :presence => { :case_sensitive => false }, :scope => :companyable_type
  validates_format_of :primary_phone, :with => /^1[358]\d{9}$|^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/, :allow_blank => true
  validates_format_of :secondary_phone, :with => /^1[358]\d{9}$|^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/, :allow_blank => true
  validate :distribution_list_check

  def distribution_list_check
    unless self.distribution_list.nil?
    	email_ary = self.distribution_list.split(%r{[,; ]\s*})
    	email_ary.each do |e|
    	  regexp = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    	  unless regexp.match(e)
    	    errors.add(:distribution_list, "email seperated by ' ',',' or ';' only ")
    	  end 
    	end
    end
  end

  def appendix_name
    self.appendix.nil?? "" : self.appendix.url.split("/").last
  end
end
