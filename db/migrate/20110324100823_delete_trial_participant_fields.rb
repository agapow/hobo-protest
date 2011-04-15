class DeleteTrialParticipantFields < ActiveRecord::Migration
  def self.up
    remove_column :trial_participants, :trial_id
    remove_column :trial_participants, :lab_id

    remove_index :trial_participants, :name => :index_trial_participants_on_lab_id rescue ActiveRecord::StatementInvalid
    remove_index :trial_participants, :name => :index_trial_participants_on_trial_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :trial_participants, :trial_id, :integer
    add_column :trial_participants, :lab_id, :integer

    add_index :trial_participants, [:lab_id]
    add_index :trial_participants, [:trial_id]
  end
end
