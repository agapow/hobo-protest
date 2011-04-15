class AddedOutcomeToSample < ActiveRecord::Migration
  def self.up
    add_column :samples, :result, :float
    add_column :samples, :outcome, :string
  end

  def self.down
    remove_column :samples, :result
    remove_column :samples, :outcome
  end
end
