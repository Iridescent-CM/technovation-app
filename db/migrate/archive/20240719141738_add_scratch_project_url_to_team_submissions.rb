class AddScratchProjectUrlToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :scratch_project_url, :string
  end
end
