class MoreManyToMany < ActiveRecord::Migration
  def self.up
    change_column :samples, :outcome, :string, :limit => 255, :default => :inconclusive

    change_column :sample_results, :outcome, :string, :limit => 255, :default => :ambiguous

    add_column :panel_test_types, :panel_id, :integer
    add_column :panel_test_types, :test_type_id, :integer

    add_index :panel_test_types, [:panel_id]
    add_index :panel_test_types, [:test_type_id]
  end

  def self.down
    change_column :samples, :outcome, :string, :default => "'--- :inconclusive\n'"

    change_column :sample_results, :outcome, :string, :default => "'--- :ambiguous\n'"

    remove_column :panel_test_types, :panel_id
    remove_column :panel_test_types, :test_type_id

    remove_index :panel_test_types, :name => :index_panel_test_types_on_panel_id rescue ActiveRecord::StatementInvalid
    remove_index :panel_test_types, :name => :index_panel_test_types_on_test_type_id rescue ActiveRecord::StatementInvalid
  end
end
