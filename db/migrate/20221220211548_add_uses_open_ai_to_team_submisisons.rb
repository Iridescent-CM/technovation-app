class AddUsesOpenAiToTeamSubmisisons < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :uses_open_ai, :boolean
    add_column :team_submissions, :uses_open_ai_description, :string
  end
end
