class AddOnboardedToStudentProfiles < ActiveRecord::Migration[5.1]
  def up
    add_column :student_profiles, :onboarded, :boolean, default: false

    StudentProfile.current.find_each do |s|
      s.update_column(:onboarded, s.can_be_marked_onboarded?)
    end
  end

  def down
    remove_column :student_profiles, :onboarded
  end
end
