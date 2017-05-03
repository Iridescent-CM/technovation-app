class AddContestRankToTeamSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :team_submissions, :contest_rank, :integer, default: 0, null: false
  end
end
