class LabTitleToName < ActiveRecord::Migration
  def self.up
    change_column :samples, :outcome, :string, :limit => 255, :default => :inconclusive

    change_column :sample_results, :outcome, :string, :limit => 255, :default => :ambiguous
  end

  def self.down
    change_column :samples, :outcome, :string, :default => "'--- :inconclusive\n'"

    change_column :sample_results, :outcome, :string, :default => "'--- :ambiguous\n'"
  end
end
