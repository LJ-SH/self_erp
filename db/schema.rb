# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130511072105) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                                                                                                                                              :default => "",           :null => false
    t.string   "encrypted_password",                                                                                                                                                 :default => "",           :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                                                                                                                      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                                                                                                                                                   :null => false
    t.datetime "updated_at",                                                                                                                                                                                   :null => false
    t.string   "user_name"
    t.string   "telephone"
    t.string   "organization"
    t.enum     "role",                   :limit => [:role_super, :role_admin, :role_dev, :role_fin, :role_plm, :role_sales, :role_material_controller, :role_service, :role_others], :default => :role_others
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true
  add_index "admin_users", ["user_name"], :name => "index_admin_users_on_user_name", :unique => true

  create_table "company_profiles", :force => true do |t|
    t.string   "company_name"
    t.string   "company_addr"
    t.string   "postcode"
    t.string   "company_desc"
    t.string   "contact"
    t.string   "primary_phone"
    t.string   "secondary_phone"
    t.string   "distribution_list"
    t.string   "appendix"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "companyable_id"
    t.string   "companyable_type"
  end

  create_table "component_categories", :force => true do |t|
    t.string   "name"
    t.string   "comment"
    t.string   "code"
    t.string   "updated_by_email"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "ancestry"
    t.integer  "ancestry_depth",   :default => 0
  end

  add_index "component_categories", ["ancestry"], :name => "index_component_categories_on_ancestry"

  create_table "suppliers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                                                                                  :null => false
    t.datetime "updated_at",                                                                                                  :null => false
    t.enum     "status",     :limit => [:company_active, :company_outdated, :company_transient], :default => :company_active
    t.string   "comment"
  end

  create_table "supply_agents", :force => true do |t|
    t.string   "name"
    t.enum     "status",     :limit => [:company_active, :company_outdated, :company_transient], :default => :company_active
    t.string   "comment"
    t.datetime "created_at",                                                                                                  :null => false
    t.datetime "updated_at",                                                                                                  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "companyable_id"
    t.string   "companyable_type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
