class AddRemovedFromJudgingPoolToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :removed_from_judging_pool, :boolean, default: false
  end
end
