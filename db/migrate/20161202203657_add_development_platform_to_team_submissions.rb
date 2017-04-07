class AddDevelopmentPlatformToTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    add_column :team_submissions, :development_platform, :string
  end
end
