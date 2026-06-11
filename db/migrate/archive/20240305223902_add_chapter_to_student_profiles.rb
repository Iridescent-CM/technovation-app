class AddChapterToStudentProfiles < ActiveRecord::Migration[6.1]
  def change
    add_reference :student_profiles, :chapter, foreign_key: true
  end
end
