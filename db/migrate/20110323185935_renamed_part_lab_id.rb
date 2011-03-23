class RenamedPartLabId < ActiveRecord::Migration
  def self.up
    rename_column :trial_participants, :participating_lab_id, :lab_id

    remove_index :trial_participants, :name => :index_trial_participants_on_participating_lab_id rescue ActiveRecord::StatementInvalid
    add_index :trial_participants, [:lab_id]
  end

  def self.down
    rename_column :trial_participants, :lab_id, :participating_lab_id

    remove_index :trial_participants, :name => :index_trial_participants_on_lab_id rescue ActiveRecord::StatementInvalid
    add_index :trial_participants, [:participating_lab_id]
  end
end
