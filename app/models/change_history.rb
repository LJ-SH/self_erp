class ChangeHistory < ActiveRecord::Base
  attr_accessible :updated_by, :updated_at, :notes
  belongs_to :trackable_obj, :polymorphic => true, :inverse_of => :change_histories
  validates_presence_of :notes
  validates_presence_of :updated_by
end
