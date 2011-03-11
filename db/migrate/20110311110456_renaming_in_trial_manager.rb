class RenamingInTrialManager < ActiveRecord::Migration
  def self.up
    rename_column :trial_managers, :user_id, :manager_id

    remove_index :trial_managers, :name => :index_trial_managers_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :trial_managers, [:manager_id]
  end

  def self.down
    rename_column :trial_managers, :manager_id, :user_id

    remove_index :trial_managers, :name => :index_trial_managers_on_manager_id rescue ActiveRecord::StatementInvalid
    add_index :trial_managers, [:user_id]
  end
end
