class CreateChangeHistories < ActiveRecord::Migration
  def change
    create_table :change_histories do |t|
      t.string :updated_by
      t.string :notes
      t.datetime :updated_at
    end
  end
end
