class Inventory < ActiveRecord::Base
  scope :part_number, where(:item_type => 'PartNumber')

  attr_accessible :item_id, :item_type, :location_id, :location_type, :quantity_of_in_manufacturing,
  				  :quantity_of_surplus, :average_price, :updated_at

  belongs_to :item, :polymorphic => true, :inverse_of => :inventories
  belongs_to :location, :polymorphic => true, :inverse_of => :inventories  
end