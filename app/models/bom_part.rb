class BomPart < ActiveRecord::Base
  belongs_to :bom, :inverse_of => :bom_parts
  belongs_to :part_number, :inverse_of => :bom_parts

  attr_accessible :id, :amount, :location, :comments, :bom_id, :part_number_id

  #attr_accessor :cc_level0, :cc_level1, :cc_level2, :component_cateogry, :supplier

  validates_numericality_of :amount, :greater_than_or_equal_to => 1, :only_integer => true
  validates_presence_of :location

  def display_name
  	self.part_number.name
  end
end
