class AddLatLngToTeams < ActiveRecord::Migration[4.2]
  def change
    add_column :teams, :latitude, :float
    add_column :teams, :longitude, :float
  end
end
