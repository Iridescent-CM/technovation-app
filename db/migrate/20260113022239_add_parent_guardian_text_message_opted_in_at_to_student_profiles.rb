class AddParentGuardianTextMessageOptedInAtToStudentProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :student_profiles, :parent_guardian_text_message_opted_in_at, :datetime
  end
end
