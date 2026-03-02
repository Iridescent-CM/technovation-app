class DropSeasonsAndSeasonRegistrations < ActiveRecord::Migration[5.1]
  def up
    drop_table :season_registrations
    drop_table :seasons
  end
end
