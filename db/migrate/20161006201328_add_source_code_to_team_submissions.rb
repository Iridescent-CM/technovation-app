class AddSourceCodeToTeamSubmissions < ActiveRecord::Migration
  def change
    add_column :team_submissions, :source_code, :string
  end
end
