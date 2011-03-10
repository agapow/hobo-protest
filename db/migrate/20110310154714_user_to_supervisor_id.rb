class UserToSupervisorId < ActiveRecord::Migration
  def self.up
    rename_column :series_supervisors, :user_id, :supervisor_id

    remove_index :series_supervisors, :name => :index_series_supervisors_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :series_supervisors, [:supervisor_id]
  end

  def self.down
    rename_column :series_supervisors, :supervisor_id, :user_id

    remove_index :series_supervisors, :name => :index_series_supervisors_on_supervisor_id rescue ActiveRecord::StatementInvalid
    add_index :series_supervisors, [:user_id]
  end
end
