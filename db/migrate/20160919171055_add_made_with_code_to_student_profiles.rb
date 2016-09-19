class AddMadeWithCodeToStudentProfiles < ActiveRecord::Migration
  def change
    add_column :student_profiles, :made_with_code, :boolean, null: false, default: false
    add_index :student_profiles, :made_with_code
  end
end
