class Product < ActiveRecord::Base
  attr_accessible :name, :pcb_ver, :bom_appendix, :sw_appendix, :tool_appendix,
                  :doc_appendix, :comment, :updated_by, :remove_bom_appendix

  # attr_accessible :title, :body
  mount_uploader :bom_appendix, AppendixUploader

  validates_presence_of :name, :allow_blank => false
  validates_presence_of :updated_by, :allow_blank => false 
  validates_format_of :name, :with => /^[a-zA-Z]{1}\d{4}[a-zA-Z]{0,1}$/, :message => :product_name_invalid
  validates_format_of :pcb_ver, :with => /^[a-zA-Z]{1}\d{2}$/, :message => :product_pcb_ver_invalid  

  has_many :production_orders, :dependent => :destroy, :inverse_of => :product
  accepts_nested_attributes_for :production_orders, :allow_destroy => true

  def bom_appendix_name
    self.bom_appendix.blank?? "" : self.bom_appendix.url.split("/").last
  end    
end