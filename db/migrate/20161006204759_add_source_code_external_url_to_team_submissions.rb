class AddSourceCodeExternalUrlToTeamSubmissions < ActiveRecord::Migration
  def change
    add_column :team_submissions, :source_code_external_url, :string
  end
end
