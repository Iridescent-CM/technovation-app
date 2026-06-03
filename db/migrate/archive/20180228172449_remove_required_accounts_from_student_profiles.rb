class RemoveRequiredAccountsFromStudentProfiles < ActiveRecord::Migration[5.1]
  def change
    change_column_null :student_profiles, :account_id, true
  end
end
