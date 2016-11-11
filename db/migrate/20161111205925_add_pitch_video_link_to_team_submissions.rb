class AddPitchVideoLinkToTeamSubmissions < ActiveRecord::Migration
  def change
    add_column :team_submissions, :pitch_video_link, :string
  end
end
