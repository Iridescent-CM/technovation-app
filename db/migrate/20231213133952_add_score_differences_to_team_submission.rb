class AddScoreDifferencesToTeamSubmission < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :quarterfinals_highest_to_lowest_score_difference, :integer
    add_column :team_submissions, :semifinals_highest_to_lowest_score_difference, :integer
  end
end
