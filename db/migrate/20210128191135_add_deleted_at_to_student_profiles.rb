class AddDeletedAtToStudentProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :student_profiles, :deleted_at, :datetime
    add_index :student_profiles, :deleted_at
  end
end
