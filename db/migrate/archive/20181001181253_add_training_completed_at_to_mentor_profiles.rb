class AddTrainingCompletedAtToMentorProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :mentor_profiles, :training_completed_at, :datetime
  end
end
