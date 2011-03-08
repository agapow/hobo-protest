class AddedLabMembersAndTrialParticipants < ActiveRecord::Migration
  def self.up
    create_table :lab_members do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :lab_id
      t.integer  :user_id
    end
    add_index :lab_members, [:lab_id]
    add_index :lab_members, [:user_id]

    create_table :trial_participants do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :trial_id
      t.integer  :lab_id
    end
    add_index :trial_participants, [:trial_id]
    add_index :trial_participants, [:lab_id]
  end

  def self.down
    drop_table :lab_members
    drop_table :trial_participants
  end
end
