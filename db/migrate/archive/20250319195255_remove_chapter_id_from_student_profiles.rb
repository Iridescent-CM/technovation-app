class RemoveChapterIdFromStudentProfiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :student_profiles, :chapter_id
  end
end
