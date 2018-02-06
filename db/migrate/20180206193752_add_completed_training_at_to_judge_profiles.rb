class AddCompletedTrainingAtToJudgeProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :judge_profiles, :completed_training_at, :datetime
  end
end
