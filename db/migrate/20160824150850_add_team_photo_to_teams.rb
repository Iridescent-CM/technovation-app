class AddTeamPhotoToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :team_photo, :string
  end
end
