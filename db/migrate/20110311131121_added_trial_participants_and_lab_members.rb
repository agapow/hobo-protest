class AddedTrialParticipantsAndLabMembers < ActiveRecord::Migration
  def self.up
    rename_column :lab_members, :user_id, :member_id

    rename_column :trial_participants, :lab_id, :participating_lab_id

    remove_index :lab_members, :name => :index_lab_members_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :lab_members, [:member_id]

    remove_index :trial_participants, :name => :index_trial_participants_on_lab_id rescue ActiveRecord::StatementInvalid
    add_index :trial_participants, [:participating_lab_id]
  end

  def self.down
    rename_column :lab_members, :member_id, :user_id

    rename_column :trial_participants, :participating_lab_id, :lab_id

    remove_index :lab_members, :name => :index_lab_members_on_member_id rescue ActiveRecord::StatementInvalid
    add_index :lab_members, [:user_id]

    remove_index :trial_participants, :name => :index_trial_participants_on_participating_lab_id rescue ActiveRecord::StatementInvalid
    add_index :trial_participants, [:lab_id]
  end
end
