class AddDemoVideoLinkToTeamSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :team_submissions, :demo_video_link, :string
  end
end
