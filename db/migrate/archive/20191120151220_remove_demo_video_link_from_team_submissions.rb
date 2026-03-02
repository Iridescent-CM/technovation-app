class RemoveDemoVideoLinkFromTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    remove_column :team_submissions, :demo_video_link, :string
  end
end
