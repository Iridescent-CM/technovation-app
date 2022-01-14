class AllowNullSubmissionTypeForTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    change_column_null(:team_submissions, :submission_type, true)
  end
end
