class AddedResult < ActiveRecord::Migration
  def self.up
    create_table :sample_results do |t|
      t.string   :title
      t.float    :result
      t.string   :outcome
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :shipment_id
      t.integer  :sample_id
    end
    add_index :sample_results, [:shipment_id]
    add_index :sample_results, [:sample_id]

    add_column :shipments, :title, :string

    change_column :samples, :description, :string, :limit => 255
    change_column :samples, :note, :string, :limit => 255
  end

  def self.down
    remove_column :shipments, :title

    change_column :samples, :description, :text
    change_column :samples, :note, :text

    drop_table :sample_results
  end
end
