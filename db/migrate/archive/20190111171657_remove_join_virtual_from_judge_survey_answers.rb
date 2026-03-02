class RemoveJoinVirtualFromJudgeSurveyAnswers < ActiveRecord::Migration[5.1]
  def change
    remove_column :judge_profiles, :join_virtual, :boolean
  end
end
