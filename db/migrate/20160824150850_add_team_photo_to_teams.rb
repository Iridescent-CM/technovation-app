class AddTeamPhotoToTeams < ActiveRecord::Migration[4.2]
  def change
    add_column :teams, :team_photo, :string
  end
end
