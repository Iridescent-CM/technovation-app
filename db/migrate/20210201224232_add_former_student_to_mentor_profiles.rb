class AddFormerStudentToMentorProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :mentor_profiles, :former_student, :boolean, default: false
  end
end
