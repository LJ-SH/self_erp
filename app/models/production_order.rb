class ProductionOrder < ActiveRecord::Base
  attr_accessible :order_id, :production_type, :manufacturing_process, :rf_frequency, :sn_start_no, 
                  :imei_start_no, :volume, :no_of_imei, :associated_bom, :associated_manufacturing_docs,
                  :associated_sw_version, :associated_test_tool_set, :ordered_by, :ordered_at, :comments,
                  :appendix_name, :appendix, :remove_appendix
  attr_accessor :appendix, :file

  belongs_to :product, :inverse_of => :production_orders
  belongs_to :oem, :inverse_of => :production_orders
  belongs_to :bom, :inverse_of => :production_orders

  def appendix_name
    self.appendix.blank?? "" : self.appendix.url.split("/").last
  end  
end
  