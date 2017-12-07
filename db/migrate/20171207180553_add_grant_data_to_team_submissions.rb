class AddGrantDataToTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions, :app_inventor_app_name, :string
    add_column :team_submissions, :app_inventor_gmail, :string
  end
end
