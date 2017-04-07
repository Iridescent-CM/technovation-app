class AddSourceCodeToTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    add_column :team_submissions, :source_code, :string
  end
end
