class AddedStringLimitsToCountryFields < ActiveRecord::Migration
  def self.up
    rename_column :labs, :country_name, :country
    change_column :labs, :short_name, :string, :limit => 16
    change_column :labs, :postal_code, :string, :limit => 16
  end

  def self.down
    rename_column :labs, :country, :country_name
    change_column :labs, :short_name, :string
    change_column :labs, :postal_code, :string
  end
end
