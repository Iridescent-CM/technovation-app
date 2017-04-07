class AddAppDescriptionToTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    add_column :team_submissions, :app_description, :text
  end
end
