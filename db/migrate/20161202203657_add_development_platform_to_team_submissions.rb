class AddDevelopmentPlatformToTeamSubmissions < ActiveRecord::Migration
  def change
    add_column :team_submissions, :development_platform, :string
  end
end
