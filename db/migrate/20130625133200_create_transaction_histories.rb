class CreateTransactionHistories < ActiveRecord::Migration
  def change
    create_table :transaction_histories do |t|
      t.references :item, polymorphic: true
      t.references :location, polymorphic: true
      t.integer  :quantity, :default => 0
      t.decimal  :average_price, :precision => 8, :scale => 2, :default => 1.0
      t.string   :created_by
      t.enum     :transaction_type, :limit => TRANSACTION_DEFINITION
      t.datetime :created_at
      t.string   :reference_obj_type
      t.integer  :reference_obj_id
      #t.timestamps
    end
  end
end
