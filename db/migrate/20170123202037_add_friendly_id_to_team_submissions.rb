class AddFriendlyIdToTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    add_column :team_submissions, :slug, :string
  end
end
