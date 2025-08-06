class AddEthicsDescriptionToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :ethics_description, :string
  end
end
