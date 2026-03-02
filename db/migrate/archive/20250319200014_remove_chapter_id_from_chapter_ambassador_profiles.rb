class RemoveChapterIdFromChapterAmbassadorProfiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :chapter_ambassador_profiles, :chapter_id
  end
end
