class RenamedTrialManagerAsSupervisor < ActiveRecord::Migration
  def self.up
    rename_table :series_managers, :series_supervisors

    remove_index :series_supervisors, :name => :index_series_managers_on_trial_series_id rescue ActiveRecord::StatementInvalid
    remove_index :series_supervisors, :name => :index_series_managers_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :series_supervisors, [:trial_series_id]
    add_index :series_supervisors, [:user_id]
  end

  def self.down
    rename_table :series_supervisors, :series_managers

    remove_index :series_managers, :name => :index_series_supervisors_on_trial_series_id rescue ActiveRecord::StatementInvalid
    remove_index :series_managers, :name => :index_series_supervisors_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :series_managers, [:trial_series_id]
    add_index :series_managers, [:user_id]
  end
end
