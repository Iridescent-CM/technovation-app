class AddSeasonsToJudgeAssignments < ActiveRecord::Migration[5.1]
  def change
    add_column :judge_assignments, :seasons, :text, array: true, default: []
  end
end
