class AddParentGuardianPhoneNumberToStudentProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :student_profiles, :parent_guardian_phone_number, :string
  end
end
