class AddReturnedByToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :returned_by_id, :integer
  end
end
