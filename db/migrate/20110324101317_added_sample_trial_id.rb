class AddedSampleTrialId < ActiveRecord::Migration
  def self.up
    add_column :samples, :trial_id, :integer

    add_index :samples, [:trial_id]
  end

  def self.down
    remove_column :samples, :trial_id

    remove_index :samples, :name => :index_samples_on_trial_id rescue ActiveRecord::StatementInvalid
  end
end
