class AddAiUsageToTeamSubmisisons < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :ai_usage, :boolean
  end
end
