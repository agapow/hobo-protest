class AddedShipment < ActiveRecord::Migration
  def self.up
    create_table :shipments do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :trial_id
      t.integer  :lab_id
    end
    add_index :shipments, [:trial_id]
    add_index :shipments, [:lab_id]
  end

  def self.down
    drop_table :shipments
  end
end
