class AddAppNameToTeamSubmission < ActiveRecord::Migration
  def change
    add_column :team_submissions, :app_name, :string
  end
end
