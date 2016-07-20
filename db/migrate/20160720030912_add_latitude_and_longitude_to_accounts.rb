class AddLatitudeAndLongitudeToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :latitude, :float, index: true
    add_column :accounts, :longitude, :float, index: true
  end
end
