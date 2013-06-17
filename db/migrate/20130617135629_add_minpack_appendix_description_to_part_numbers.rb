class AddMinpackAppendixDescriptionToPartNumbers < ActiveRecord::Migration
  def change
  	add_column :part_numbers, :min_amount, :integer, :default => 1
  	add_column :part_numbers, :description, :string
  	add_column :part_numbers, :appendix, :string  	
  end
end
