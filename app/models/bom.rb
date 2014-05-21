#class Bom < ActiveRecord::Base
#  ## start of state defintion ==========================================
#  after_initialize do
#    #logger.info 'after_initialize is invoked'
#    self.before_transition_state = self.status
#  end 

#  attr_accessible :prepared_by, :approved_by, :status, :change_histories_attributes
#  attr_accessor :before_transition_state

#  # DEFAULT_STATUS_DEFINITION = [:status_in_progress, :status_pending_approval, :status_active, :status_transient, :status_outdated]
#  @@status_collection = DEFAULT_STATUS_DEFINITION
#  @@status_collection_max_index = @@status_collection.size-1

#  validates_presence_of :prepared_by
#  validates_presence_of :approved_by, :unless => Proc.new{|bom| @@status_collection[0..1].include?(bom.status)}

#  has_many :change_histories, :as => :trackable_obj, :dependent => :destroy, :inverse_of => :trackable_obj
#  accepts_nested_attributes_for :change_histories, :allow_destroy => true

#  def status_select_collection
#    if self.new_record?
#      return @@status_collection[0..0]
#    else 
#      case before_transition_state
#        when @@status_collection[0] then @@status_collection[0..1] 
#        when @@status_collection[1] then @@status_collection[1..2]
#        when @@status_collection[2] then @@status_collection[2..3]
#        when @@status_collection[3] then @@status_collection[3..4]  
#        else @@status_collection[@@status_collection_max_index..@@status_collection_max_index]
#      end 
#    end
#  end

#  def display_approved_by?
#    @@status_collection[1..4].include?(self.before_transition_state) 
#  end

#  def model_fixed?
#    @@status_collection[2..4].include?(self.before_transition_state)
#  end
#  ## end of state definition ==============================================
class Bom < StatefulObj  
  scope :status_active, where(:status => :status_active)
  scope :status_outdated, where(:status => :status_outdated)
  scope :status_transient, where(:status => :status_transient)
  scope :status_pending_approval, where(:status => :status_pending_approval)
  scope :status_in_progress, where(:status => :status_in_progress)  
  scope :good_to_be_parent_bom, where(:status => @@status_collection[0..2])

  after_create :clone_bom_if_any
  attr_accessible :name, :code, :description, :version, 
                  :total_number_of_categories, :total_number_of_items, :parent_bom_id

  attr_accessor :total_number_of_items, :total_number_of_categories

  attr_accessor :target_bom_id, :display_option

  has_many :bom_parts, :dependent => :destroy, :inverse_of => :bom
  accepts_nested_attributes_for :bom_parts, :allow_destroy => true

  has_many :production_orders, :dependent => :destroy, :inverse_of => :bom
  accepts_nested_attributes_for :production_orders, :allow_destroy => true

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :version
  validates_presence_of :code
  validates_uniqueness_of :code, :allow_blank => false

  def total_number_of_items
  	self.bom_parts.sum(:amount)
  end

  def total_number_of_categories
  	self.bom_parts.size
  end    

  def clone_bom_if_any
    unless self.parent_bom_id.blank?
      parent_bom = Bom.find(self.parent_bom_id)
      if parent_bom.nil?
        errors.add(:parent_bom_id, "parent_bom_id was deleted")
      else 
        # delete all bom_part under the current bom_id
        BomPart.delete_all(:bom_id => self.id)
        # clone bom_parts from parent to current
        parent_bom.bom_parts.each do |bom_part|
          bom_part.dup.update_attributes!(:bom_id => self.id)
        end
      end
    end
  end

  def parent_bom_collection
    if self.model_fixed?
      if self.parent_bom_id.blank?
        [[I18n.t("helpers.select.empty_option"),'']]
      else
        [[Bom.find(self.parent_bom_id).name, self.parent_bom_id]]
      end
    else
      [[I18n.t("helpers.select.parent_bom_id_prompt"),'']]+Bom.good_to_be_parent_bom.reject{|bom| bom.id == self.id}.map{|bom| ["#{bom.name}", bom.id]}
    end
  end
end

#class Bom < ActiveRecord::Base
#  after_initialize :set_approval_state 

#  after_create :clone_bom_if_any
#  attr_accessible :name, :status, :code, :description, :version, :prepared_by, :approved_by, 
#                  :total_number_of_categories, :total_number_of_items, :parent_bom_id

#  attr_accessor :total_number_of_items, :total_number_of_categories, :bApproved

#  scope :status_active, where(:status => :status_active)
#  scope :status_outdated, where(:status => :status_outdated)
#  scope :status_transient, where(:status => :status_transient)
#  scope :status_pending_approval, where(:status => :status_pending_approval)
#  scope :status_in_progress, where(:status => :status_in_progress)
#  scope :good_to_be_parent_bom, where(:status => [:status_in_progress, :status_pending_approval, :status_active])

#  has_many :change_histories, :as => :trackable_obj, :dependent => :destroy, :inverse_of => :trackable_obj
#  accepts_nested_attributes_for :change_histories, :allow_destroy => true

#  has_many :bom_parts, :dependent => :destroy, :inverse_of => :bom
#  accepts_nested_attributes_for :bom_parts, :allow_destroy => true

#  validates_uniqueness_of :name, :allow_blank => false
#  validates_presence_of :version
#  validates_presence_of :prepared_by
#  validates_presence_of :approved_by, :unless => Proc.new{|bom| BOM_STATUS_DEFINITION[0..1].include?(bom.status)}

#  def total_number_of_items
#    self.bom_parts.sum(:amount)
#  end

#  def total_number_of_categories
#    self.bom_parts.size
#  end    

#  def status_not_in_preparation?
#    self.status != :status_in_progress || self.status.blank?
#  end

#  def bom_status_collection
#    if self.new_record?
#      return BOM_STATUS_DEFINITION[0..0]
#    else 
#        case bApproved
#          when :status_active then BOM_STATUS_DEFINITION[2..3]
#          when :status_transient then BOM_STATUS_DEFINITION[3..4]  
#          when :status_in_progress then BOM_STATUS_DEFINITION[0..1]          
#          else BOM_STATUS_DEFINITION[1..2]
#        end 
#    end
#  end

#  def clone_bom_if_any
#    unless self.parent_bom_id.blank?
#      parent_bom = Bom.find(self.parent_bom_id)
#      if parent_bom.nil?
#        errors.add(:parent_bom_id, "parent_bom_id was deleted")
#      else 
#        parent_bom.bom_parts.each do |bom_part|
#          bom_part.dup.update_attributes!(:bom_id => self.id)
#        end
#      end
#    end
#  end

#  private
#  def set_approval_state
#    self.bApproved = self.status
#  end  
#end