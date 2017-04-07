class AddPitchVideoLinkToTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    add_column :team_submissions, :pitch_video_link, :string
  end
end
