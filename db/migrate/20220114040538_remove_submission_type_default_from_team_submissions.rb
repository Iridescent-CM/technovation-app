class RemoveSubmissionTypeDefaultFromTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:team_submissions, :submission_type, nil)
  end
end
