class AddPitchPresentationToTeamSubmissions < ActiveRecord::Migration
  def change
    add_column :team_submissions, :pitch_presentation, :string
  end
end
