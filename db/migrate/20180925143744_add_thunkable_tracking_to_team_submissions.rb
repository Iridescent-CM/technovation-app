class AddThunkableTrackingToTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions, :thunkable_account_email, :string
    add_column :team_submissions, :thunkable_project_url, :string
  end
end
