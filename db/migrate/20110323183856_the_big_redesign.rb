class TheBigRedesign < ActiveRecord::Migration
  def self.up
    drop_table :trial_series
    drop_table :series_supervisors
    drop_table :trial_managers

    remove_column :trials, :trial_series_id

    remove_index :trials, :name => :index_trials_on_trial_series_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :trials, :trial_series_id, :integer

    create_table "trial_series", :force => true do |t|
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "description"
    end

    create_table "series_supervisors", :force => true do |t|
      t.integer "supervisor_id"
      t.integer "trial_series_id"
    end

    add_index "series_supervisors", ["supervisor_id"], :name => "index_series_supervisors_on_supervisor_id"
    add_index "series_supervisors", ["trial_series_id"], :name => "index_series_supervisors_on_trial_series_id"

    create_table "trial_managers", :force => true do |t|
      t.integer "manager_id"
      t.integer "trial_id"
    end

    add_index "trial_managers", ["manager_id"], :name => "index_trial_managers_on_manager_id"
    add_index "trial_managers", ["trial_id"], :name => "index_trial_managers_on_trial_id"

    add_index :trials, [:trial_series_id]
  end
end
