class AddDeletedAtToTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions, :deleted_at, :datetime
  end
end
