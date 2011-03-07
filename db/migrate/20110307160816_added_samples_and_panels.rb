class AddedSamplesAndPanels < ActiveRecord::Migration
  def self.up
    create_table :samples do |t|
      t.string   :title
      t.text     :description
      t.text     :note
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :panels do |t|
      t.string   :title
      t.text     :description
      t.text     :note
      t.datetime :created_at
      t.datetime :updated_at
    end

    rename_column :trials, :closes, :closing
    add_column :trials, :opening, :datetime
  end

  def self.down
    rename_column :trials, :closing, :closes
    remove_column :trials, :opening

    drop_table :samples
    drop_table :panels
  end
end
