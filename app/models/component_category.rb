class ComponentCategory < ActiveRecord::Base
  before_destroy :check_and_delete_children
  has_ancestry(:cache_depth => true)
  # attr_accessible :title, :body
  attr_accessible :name, :code, :updated_by_email, :parent, :ancestry,:ancestry_depth,
                  :level0, :level1, :level2, :comment, :part_numbers_attributes

  has_many :part_numbers, :dependent => :destroy, :inverse_of => :component_category
  accepts_nested_attributes_for :part_numbers, :allow_destroy => true  

  validates_presence_of :name
  validates_presence_of :code
  validates_uniqueness_of :name, :scope => [:ancestry]
  validates_uniqueness_of :code, :scope => [:ancestry]	
  validates_format_of :code, :with => /\A([0][1-9]|[1-9][0-9])$\z/
  validates :updated_by_email, :presence => { :case_sensitive => false }	
  validates_format_of :updated_by_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i  

  scope :depth0, where(:ancestry_depth => 0)
  scope :depth1, where(:ancestry_depth => 1)
  scope :depth2, where(:ancestry_depth => 2)
  scope :depth3, where(:ancestry_depth => 3) 
  scope :valid_depth0_collection, depth0.select{|c| c.descendants.exists?(:ancestry_depth => 3)}

  attr_accessor :level0, :level1, :level2

  def level0
    self.root_id
  end

  def level1
    self.ancestor_ids[1]
  end

  def level2
    self.ancestor_ids[2]
  end

  def end_node?
	  #self.ancestry_depth==3?  true:false
    self.children.empty?
  end  

  def full_display
    unless self.ancestors.nil? 
      @full_name = self.path.to_ary.map{|c| "#{c.name}(#{c.code})"}
      @full_name.join("-")
    end    
  end

  def ancestor_display
    unless self.ancestors.nil? 
      @parents_name = self.ancestors.to_ary.map{|c| "#{c.name}(#{c.code})"}
      @parents_name.join("-")
    end
  end

  def code_generator
    unless (self.ancestors.nil? || self.ancestry_depth != 3) 
      @code = self.path.to_ary.map{|c| "#{c.code}"}
      @code.join
    end
  end

  def partial_code
    self.path.to_ary.map{|c| "#{c.code}"}.join
  end

  #def associated_parts (id, group_id)
    #self.part_numbers.reject{|pn| pn.group_id.blank? || pn.group_id != group_id || pn.id == id}
    #self.part_numbers.select{|pn| pn.group_id? && pn.group_id == group_id && pn.id != id}
  #end

  def group_id_options
    # In reality, each group shall include at least 2 components so that the maximum
    # group number is half of size. 
    #@size = self.part_numbers.size
    #[""] + Array.new(@size.even?? @size.div(2):@size.div(2)+1) {|i| i+1}
    [""] + Array.new(self.part_numbers.size.div(2)) {|i| i+1}
  end

  def preference_options
    [""] + Array.new(self.part_numbers.size) {|i| i+1}
  end

  def check_and_delete_children
    # the below checking is for test purpose
    if self.ancestry_depth == 3 
        self.errors.add(:base, :destroy_fails_if_in_use, :categoryname => self.name)
      return false
    end   
    self.children.each do |c|
      unless c.destroy
      self.errors[:base].concat(c.errors[:base]);
      self.errors.add(:base, :destroy_fails_if_children_exist, :childname => c.name) 
      return false
      end
    end
  end

  def end_leaves
    self.subtree.select{|node| node.end_node?}
  end

  scope :level0_eq, lambda {|id| ComponentCategory.find(id).subtree unless id.nil?} 
  scope :level1_eq, lambda {|id| ComponentCategory.find(id).subtree unless id.nil?} 
  scope :level2_eq, lambda {|id| ComponentCategory.find(id).subtree unless id.nil?}
  search_methods :level0_eq, :level1_eq, :level2_eq

end
