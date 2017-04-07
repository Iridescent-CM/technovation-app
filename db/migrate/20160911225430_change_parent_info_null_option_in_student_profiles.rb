class ChangeParentInfoNullOptionInStudentProfiles < ActiveRecord::Migration[4.2]
  def change
    change_column_null :student_profiles, :parent_guardian_name, true
    change_column_null :student_profiles, :parent_guardian_email, true
  end
end
