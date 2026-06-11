class AddSourceCodeExternalUrlBackToTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions, :source_code_external_url, :string
  end
end
