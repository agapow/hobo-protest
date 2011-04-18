# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110418180211) do

  create_table "labs", :force => true do |t|
    t.string   "title"
    t.string   "short_name",     :limit => 16
    t.string   "institute"
    t.string   "street_address"
    t.string   "locality"
    t.string   "region"
    t.string   "postal_code",    :limit => 16
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact"
  end

  create_table "panels", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name"
    t.integer  "test_type_id"
  end

  add_index "panels", ["test_type_id"], :name => "index_panels_on_test_type_id"

  create_table "sample_results", :force => true do |t|
    t.string   "title"
    t.float    "result"
    t.string   "outcome",     :default => "'--- :ambiguous\n'"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shipment_id"
    t.integer  "sample_id"
  end

  add_index "sample_results", ["sample_id"], :name => "index_sample_results_on_sample_id"
  add_index "sample_results", ["shipment_id"], :name => "index_sample_results_on_shipment_id"

  create_table "samples", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "panel_id"
    t.integer  "trial_id"
    t.float    "result"
    t.string   "outcome",     :default => "'--- :inconclusive\n'"
  end

  add_index "samples", ["panel_id"], :name => "index_samples_on_panel_id"
  add_index "samples", ["trial_id"], :name => "index_samples_on_trial_id"

  create_table "shipments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trial_id"
    t.integer  "lab_id"
    t.string   "title"
  end

  add_index "shipments", ["lab_id"], :name => "index_shipments_on_lab_id"
  add_index "shipments", ["trial_id"], :name => "index_shipments_on_trial_id"

  create_table "test_types", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trial_participants", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trials", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "closing"
    t.datetime "opening"
  end

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "active"
    t.datetime "key_timestamp"
    t.string   "user_name"
    t.integer  "lab_id"
  end

  add_index "users", ["lab_id"], :name => "index_users_on_lab_id"
  add_index "users", ["state"], :name => "index_users_on_state"

end
