class ManyToManyOnPanelsAndTestTypes < ActiveRecord::Migration
  def self.up
    create_table :panel_test_types do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end

    change_column :samples, :outcome, :string, :limit => 255, :default => :inconclusive

    remove_column :panels, :test_type_id

    change_column :sample_results, :outcome, :string, :limit => 255, :default => :ambiguous

    remove_index :panels, :name => :index_panels_on_test_type_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    change_column :samples, :outcome, :string, :default => "'--- :inconclusive\n'"

    add_column :panels, :test_type_id, :integer

    change_column :sample_results, :outcome, :string, :default => "'--- :ambiguous\n'"

    drop_table :panel_test_types

    add_index :panels, [:test_type_id]
  end
end
