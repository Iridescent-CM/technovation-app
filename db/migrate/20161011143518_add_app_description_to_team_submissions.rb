class AddAppDescriptionToTeamSubmissions < ActiveRecord::Migration
  def change
    add_column :team_submissions, :app_description, :text
  end
end
