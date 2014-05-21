class CreateProductionOrders < ActiveRecord::Migration
  def change
    create_table :production_orders do |t|
      t.string    :order_id, :null => false
      t.enum      :production_type, :limit => PRODUCTION_TYPE_DEFINITION
      t.enum      :manufacturing_process, :limit => MANUFACTURING_PROCESS_DEFINITION
      t.enum      :rf_frequency, :limit => RF_FREQ_DEFINITION
      t.integer   :sn_start_no
      t.integer   :imei_start_no
      t.integer   :volume
      t.integer   :no_of_imei
      t.string    :associated_bom
      t.string    :associated_manufacturing_docs
      t.string    :associated_sw_version
      t.string    :associated_test_tool_set
      t.text  	  :comments
      t.string    :appendix
      t.string    :ordered_by
      t.datetime  :ordered_at
      t.integer   :bom_id, :null => false
      t.integer   :product_id
      t.integer   :oem_id, :null => false       
      t.timestamps
    end
  end
end
