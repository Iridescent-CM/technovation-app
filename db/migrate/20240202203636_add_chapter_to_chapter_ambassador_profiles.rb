class AddChapterToChapterAmbassadorProfiles < ActiveRecord::Migration[6.1]
  def change
    add_reference :chapter_ambassador_profiles, :chapter, foreign_key: true
  end
end
