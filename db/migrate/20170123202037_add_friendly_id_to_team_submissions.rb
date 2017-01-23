class AddFriendlyIdToTeamSubmissions < ActiveRecord::Migration
  def change
    add_column :team_submissions, :slug, :string
  end
end
