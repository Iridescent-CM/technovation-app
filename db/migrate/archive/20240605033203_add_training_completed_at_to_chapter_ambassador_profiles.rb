class AddTrainingCompletedAtToChapterAmbassadorProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :chapter_ambassador_profiles, :training_completed_at, :datetime
  end
end
