class AddedShortnameToPanel < ActiveRecord::Migration
  def self.up
    add_column :panels, :short_name, :string
  end

  def self.down
    remove_column :panels, :short_name
  end
end
