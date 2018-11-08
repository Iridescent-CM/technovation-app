class AddGeocodingFixedAtToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :geocoding_city_was, :string
    add_column :accounts, :geocoding_state_was, :string
    add_column :accounts, :geocoding_country_was, :string
    add_column :accounts, :geocoding_fixed_at, :timestamp
  end
end
