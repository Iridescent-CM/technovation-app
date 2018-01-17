class AddPublishedAtToTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions, :published_at, :datetime
  end
end
