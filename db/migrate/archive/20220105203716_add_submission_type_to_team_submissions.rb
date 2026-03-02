class AddSubmissionTypeToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :submission_type, :integer, default: 0, null: false
  end
end
