class AddAppNameToTeamSubmission < ActiveRecord::Migration[4.2]
  def change
    add_column :team_submissions, :app_name, :string
  end
end
