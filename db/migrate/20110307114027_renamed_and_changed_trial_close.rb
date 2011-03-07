class RenamedAndChangedTrialClose < ActiveRecord::Migration
  def self.up
    add_column :trials, :closes, :datetime
    add_column :trials, :trial_series_id, :integer
    remove_column :trials, :closeDate

    add_column :trial_series, :description, :text

    add_index :trials, [:trial_series_id]
  end

  def self.down
    remove_column :trials, :closes
    remove_column :trials, :trial_series_id
    add_column :trials, :closeDate, :date

    remove_column :trial_series, :description

    remove_index :trials, :name => :index_trials_on_trial_series_id rescue ActiveRecord::StatementInvalid
  end
end
