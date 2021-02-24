class AddAppDetailsToTeamSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :team_submissions, :ai, :boolean
    add_column :team_submissions, :ai_description, :string

    add_column :team_submissions, :climate_change, :boolean
    add_column :team_submissions, :climate_change_description, :string

    add_column :team_submissions, :game, :boolean
    add_column :team_submissions, :game_description, :string
  end
end
