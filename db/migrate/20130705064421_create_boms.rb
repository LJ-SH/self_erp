class CreateBoms < ActiveRecord::Migration
  def change
    create_table :boms do |t|
      t.string :name
      t.string  :description
      t.string :code
      t.string :version
      t.string :prepared_by
      t.string :approved_by      
      t.enum :status, :limit => BOM_STATUS_DEFINITION, :default => BOM_STATUS_DEFINITION[0]
      t.timestamps
    end
  end
end
