class AddBibliographyUploaderToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :bibliography, :string
  end
end
