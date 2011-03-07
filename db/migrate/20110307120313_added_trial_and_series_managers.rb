class AddedTrialAndSeriesManagers < ActiveRecord::Migration
  def self.up
    create_table :trial_managers do |t|
      t.integer :user_id
      t.integer :trial_id
    end
    add_index :trial_managers, [:user_id]
    add_index :trial_managers, [:trial_id]

    create_table :series_managers do |t|
      t.integer :user_id
      t.integer :trial_series_id
    end
    add_index :series_managers, [:user_id]
    add_index :series_managers, [:trial_series_id]

    add_column :users, :user_name, :string
  end

  def self.down
    remove_column :users, :user_name

    drop_table :trial_managers
    drop_table :series_managers
  end
end
