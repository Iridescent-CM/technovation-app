class AddPitchPresentationToTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    add_column :team_submissions, :pitch_presentation, :string
  end
end
