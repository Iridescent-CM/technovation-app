class AddSourceCodeExternalUrlToTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    add_column :team_submissions, :source_code_external_url, :string
  end
end
