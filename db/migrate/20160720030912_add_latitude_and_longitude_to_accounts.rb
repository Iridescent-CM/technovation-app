class AddLatitudeAndLongitudeToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :latitude, :float, index: true
    add_column :accounts, :longitude, :float, index: true
  end
end
