class AddDevelopmentPlatformOtherUrlToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :development_platform_other_url, :string
  end
end
