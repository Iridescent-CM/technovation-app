class AddPitchPresentationUploaderToTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions, :pitch_presentation, :string
  end
end
