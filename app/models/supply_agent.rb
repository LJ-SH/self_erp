class SupplyAgent < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :users_attributes, :company_profile_attributes, :comment, :status
  attr_accessor :appendix, :file

  has_many :users, :as => :companyable, :dependent => :destroy, :inverse_of => :companyable 
  has_one :company_profile, :as => :companyable, :dependent => :destroy, :inverse_of => :companyable
  accepts_nested_attributes_for :users, :company_profile, :allow_destroy => true

  validates :name, :uniqueness => true,  :presence => { :case_sensitive => false }

  scope :company_active, where(:status => :company_active)
  scope :company_outdated, where(:status => :company_outdated)
  scope :company_transient, where(:status => :company_transient)

  def display_name
  	self.company_profile.nil?? "#{self.name}" : "#{self.company_profile.company_name}"
  end

  # scope and search function areas, comment-by-LJ on 4-May-2013
  scope :company_name_eq, lambda{|id| Supplier.joins(:company_profile).where(:id => id)}
  scope :company_desc_contains, lambda{|c| Supplier.joins(:company_profile).where("company_desc LIKE ?", "%#{c}%")}
  scope :contact_contains, lambda{|c| Supplier.joins(:company_profile).where("contact LIKE ?", "%#{c}%")}
  scope :email_contains, lambda{|e| Supplier.uniq.joins(:users).where("email LIKE ?", "%#{e}%")}
  search_methods :company_name_eq, :contact_contains, :email_contains, :company_desc_contains
end
