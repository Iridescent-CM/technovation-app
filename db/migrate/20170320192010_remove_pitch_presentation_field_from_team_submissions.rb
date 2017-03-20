class RemovePitchPresentationFieldFromTeamSubmissions < ActiveRecord::Migration
  def change
    remove_column :team_submissions, :pitch_presentation, :string
  end
end
