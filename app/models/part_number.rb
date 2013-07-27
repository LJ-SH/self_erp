class PartNumber < ActiveRecord::Base
  after_initialize :set_approval_state

  scope :status_active, where(:status => :status_active)
  scope :status_outdated, where(:status => :status_outdated)
  scope :status_transient, where(:status => :status_transient)
  scope :status_pending_approval, where(:status => :status_pending_approval)
  scope :same_category_parts, 
        ->(pn) {pn.group_id.blank?? where(:id => pn.id) : where("group_id = ? and component_category_id = ?", pn.group_id, pn.component_category_id)}

  attr_accessible :name, :status, :latest_price, :code, :vendor_code, :reserved_code, 
                  :cc_level0, :cc_level1, :cc_level2, :cc, :cc_code, 
                  :component_category_id, :supplier_id, :prepared_by, :approved_by,
                  :group_id, :preference, :min_amount, :description,
                  :change_histories_attributes, 
                  :appendix_name, :appendix, :remove_appendix, :id, :old_code

  attr_accessor :reserved_code, :cc_level0, :cc_level1, :cc_level2, :cc_code, :bApproved

  belongs_to :supplier, :inverse_of => :part_numbers
  belongs_to :component_category, :inverse_of => :part_numbers

  mount_uploader :appendix, AppendixUploader

  has_many :change_histories, :as => :trackable_obj, :dependent => :destroy, :inverse_of => :trackable_obj
  accepts_nested_attributes_for :change_histories, :allow_destroy => true

  has_many :inventories, :as => :item, :dependent => :destroy, :inverse_of => :item
  accepts_nested_attributes_for :inventories, :allow_destroy => true
  has_many :transaction_histories, :as => :item, :dependent => :destroy, :inverse_of => :item
  accepts_nested_attributes_for :transaction_histories, :allow_destroy => true

  has_many :bom_parts, :dependent => :destroy
  accepts_nested_attributes_for :bom_parts, :allow_destroy => true

  validates_presence_of :name, :allow_blank => false
  #validates_numericality_of :latest_price, :allow_blank => true
  validates :latest_price, :numericality => {:greater_than_or_equal_to => 0.01}, :allow_blank => true
  validates_uniqueness_of :code, :message => :pn_taken
  validates_format_of :code, :with => /^\d{8}-\d{4}-\d{3}$/, :message => :pn_invalid
  validates_presence_of :prepared_by
  validates_presence_of :approved_by, :unless => Proc.new{|pn| pn.status.to_s.eql?('status_pending_approval')}
  validates_presence_of :preference, :unless => Proc.new{|pn| pn.group_id.blank?}, :message => :pn_preference_empty
  validates_uniqueness_of :preference, :scope => [:component_category_id, :group_id], :allow_blank => true, :message => :pn_preference_taken

  def associated_component_category
    self.component_category.full_display
  end

  def associated_supplier
    self.supplier.company_profile.company_name
  end

  def status_eql?(status_code)
    self.status.to_s.eql?(status_code)
  end

  def cc
  	ComponentCategory.find(self.component_category_id) unless self.component_category_id.nil?
  end

  def cc_level0
  	cc.root_id unless cc.nil?
  end 

  def cc_level1
  	cc.ancestor_ids[1] unless cc.nil?
  end

  def cc_level2
  	cc.ancestor_ids[2] unless cc.nil?
  end

  def cc_level3
  	cc.ancestor_ids[3] unless cc.nil?
  end

  def cc_code
    cc.code_generator unless self.component_category_id.nil?
  end

  def appendix_name
    self.appendix.nil?? "" : self.appendix.url.split("/").last
  end

  def associated_parts
    #self.component_category.part_numbers.select{|pn| pn.group_id? && pn.group_id == self.group_id && pn.id != self.id}
    self.similar_parts.reject{|pn|  pn.id == self.id}
  end

  def similar_parts
    self.group_id.blank?? [self] : self.component_category.part_numbers.select{|pn| pn.group_id == self.group_id}
  end

  scope :cc_level0_eq, lambda {|id| PartNumber.where("code LIKE ?", "#{ComponentCategory.find(id).partial_code}%") unless id.nil?} 
  scope :cc_level1_eq, lambda {|id| PartNumber.where("code LIKE ?", "#{ComponentCategory.find(id).partial_code}%") unless id.nil?} 
  scope :cc_level2_eq, lambda {|id| PartNumber.where("code LIKE ?", "#{ComponentCategory.find(id).partial_code}%") unless id.nil?}
  scope :cc_level3_eq, lambda {|id| PartNumber.where("code LIKE ?", "#{ComponentCategory.find(id).partial_code}%") unless id.nil?}
  search_methods :cc_level0_eq, :cc_level1_eq, :cc_level2_eq, :cc_level3_eq

  private
    def set_approval_state
      self.bApproved = true unless self.status_eql?(STATUS_DEFINITION[0].to_s)
    end
end