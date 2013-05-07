class RenameColumnAppendixLink < ActiveRecord::Migration
  def change
  	change_table :company_profiles do |t|
      t.rename :appendix_link, :appendix
    end
  end
end
