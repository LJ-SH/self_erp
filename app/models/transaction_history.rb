class TransactionHistory < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :item, :inverse_of => :transaction_histories  
  belongs_to :reference_obj, :polymorphic => true, :inverse_of => :transaction_histories
  belongs_to :location, :polymorphic => true, :inverse_of => :transaction_histories
end


Inventory.create!(:item_id => 829, :item_type => 'PartNumber', :average_price => 1.0, :volume_of_surplus => '',:location_type => 'Oem', :location_id => 3)