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

ActiveRecord::Schema.define(:version => 20110308161453) do

  create_table "lab_members", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lab_id"
    t.integer  "user_id"
  end

  add_index "lab_members", ["lab_id"], :name => "index_lab_members_on_lab_id"
  add_index "lab_members", ["user_id"], :name => "index_lab_members_on_user_id"

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
  end

  create_table "panels", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "samples", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series_managers", :force => true do |t|
    t.integer "user_id"
    t.integer "trial_series_id"
  end

  add_index "series_managers", ["trial_series_id"], :name => "index_series_managers_on_trial_series_id"
  add_index "series_managers", ["user_id"], :name => "index_series_managers_on_user_id"

  create_table "trial_managers", :force => true do |t|
    t.integer "user_id"
    t.integer "trial_id"
  end

  add_index "trial_managers", ["trial_id"], :name => "index_trial_managers_on_trial_id"
  add_index "trial_managers", ["user_id"], :name => "index_trial_managers_on_user_id"

  create_table "trial_participants", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trial_id"
    t.integer  "lab_id"
  end

  add_index "trial_participants", ["lab_id"], :name => "index_trial_participants_on_lab_id"
  add_index "trial_participants", ["trial_id"], :name => "index_trial_participants_on_trial_id"

  create_table "trial_series", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "trials", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "closing"
    t.integer  "trial_series_id"
    t.datetime "opening"
  end

  add_index "trials", ["trial_series_id"], :name => "index_trials_on_trial_series_id"

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
  end

  add_index "users", ["state"], :name => "index_users_on_state"

end
