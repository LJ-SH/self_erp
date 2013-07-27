class Bom < ActiveRecord::Base

  attr_accessible :name, :status, :code, :description, :version, :prepared_by, :approved_by, 
                  :total_number_of_categories, :total_number_of_items

  attr_accessor :total_number_of_items, :total_number_of_categories

  scope :status_active, where(:status => :status_active)
  scope :status_outdated, where(:status => :status_outdated)
  scope :status_transient, where(:status => :status_transient)
  scope :status_pending_approval, where(:status => :status_pending_approval)
  scope :status_in_progress, where(:status => :status_in_progress)

  has_many :change_histories, :as => :trackable_obj, :dependent => :destroy, :inverse_of => :trackable_obj
  accepts_nested_attributes_for :change_histories, :allow_destroy => true

  has_many :bom_parts, :dependent => :destroy
  accepts_nested_attributes_for :bom_parts, :allow_destroy => true

  def total_number_of_items
  	self.bom_parts.sum(:amount)
  end

  def total_number_of_categories
  	self.bom_parts.size
  end    
end
