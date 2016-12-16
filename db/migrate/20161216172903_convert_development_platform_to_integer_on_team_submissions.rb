class ConvertDevelopmentPlatformToIntegerOnTeamSubmissions < ActiveRecord::Migration
  def up
    add_column :team_submissions, :development_platform_other, :string
    remove_column :team_submissions, :development_platform
    add_column :team_submissions, :development_platform, :integer
  end

  def down
    change_column :team_submissions, :development_platform, :string
    remove_column :team_submissions, :development_platform_other
  end
end
