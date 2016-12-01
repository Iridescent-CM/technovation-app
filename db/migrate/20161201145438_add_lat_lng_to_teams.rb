class AddLatLngToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :latitude, :float
    add_column :teams, :longitude, :float
  end
end
