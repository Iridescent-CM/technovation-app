class AddReturnedToJudgingPoolByToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :returned_to_judging_pool_by_account_id, :integer
  end
end
