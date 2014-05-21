class StatefulObj < ActiveRecord::Base
  self.abstract_class = true
  
  ## start of state defintion ==========================================
  after_initialize do
    logger.info 'after_initialize is invoked'
    self.before_transition_state = self.status
  end 

  attr_accessible :prepared_by, :approved_by, :status, :change_histories_attributes
  attr_accessor :before_transition_state

  # DEFAULT_STATUS_DEFINITION = [:status_in_progress, :status_pending_approval, :status_active, :status_transient, :status_outdated]
  @@status_collection = DEFAULT_STATUS_DEFINITION
  @@status_collection_max_index = @@status_collection.size-1

  # scope defintion moved to specific model area

  validates_presence_of :prepared_by
  validates_presence_of :approved_by, :unless => Proc.new{|obj| @@status_collection[0..1].include?(obj.status)}

  has_many :change_histories, :as => :trackable_obj, :dependent => :destroy, :inverse_of => :trackable_obj
  accepts_nested_attributes_for :change_histories, :allow_destroy => true 

  def status_select_collection
    if self.new_record?
      return @@status_collection[0..0]
    else 
      case before_transition_state
        when @@status_collection[0] then @@status_collection[0..1] 
        when @@status_collection[1] then @@status_collection[1..2]
        when @@status_collection[2] then @@status_collection[2..3]
        when @@status_collection[3] then @@status_collection[3..4]  
        else @@status_collection[@@status_collection_max_index..@@status_collection_max_index]
      end 
    end
  end

  def display_approved_by?
    @@status_collection[1..4].include?(self.before_transition_state) 
  end

  def model_fixed?
    @@status_collection[2..4].include?(self.before_transition_state)
  end 
  ## end of state definition ==============================================

end