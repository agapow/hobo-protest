class AddedTrialseriesTrialsAndCountries < ActiveRecord::Migration
  def self.up
    create_table :labs do |t|
      t.string   :title
      t.string   :short_name
      t.string   :institute
      t.string   :street_address
      t.string   :locality
      t.string   :region
      t.string   :postal_code
      t.string   :country_name
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :trial_series do |t|
      t.string   :title
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :trials do |t|
      t.string   :title
      t.date     :closeDate
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :labs
    drop_table :trial_series
    drop_table :trials
  end
end
