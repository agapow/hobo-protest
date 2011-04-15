class AddedTestAndSampleTypes < ActiveRecord::Migration
  def self.up
    create_table :sample_types do |t|
      t.string   :title
      t.string   :description
      t.string   :units
      t.string   :note
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :test_types do |t|
      t.string   :title
      t.string   :description
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :sample_type_id
    end
    add_index :test_types, [:sample_type_id]

    add_column :samples, :sample_type_id, :integer
    add_column :samples, :panel_id, :integer

    add_index :samples, [:sample_type_id]
    add_index :samples, [:panel_id]
  end

  def self.down
    remove_column :samples, :sample_type_id
    remove_column :samples, :panel_id

    drop_table :sample_types
    drop_table :test_types

    remove_index :samples, :name => :index_samples_on_sample_type_id rescue ActiveRecord::StatementInvalid
    remove_index :samples, :name => :index_samples_on_panel_id rescue ActiveRecord::StatementInvalid
  end
end
