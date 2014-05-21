class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :pcb_ver
      t.string :bom_appendix
      t.string :sw_appendix
      t.string :tool_appendix
      t.string :doc_appendix
      t.string :comment
      t.string :updated_by
      t.timestamps
    end
  end
end
