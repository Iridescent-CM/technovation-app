class RemovePitchPresentationFieldFromTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    remove_column :team_submissions, :pitch_presentation, :string
  end
end
