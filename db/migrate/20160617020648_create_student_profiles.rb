class CreateStudentProfiles < ActiveRecord::Migration
  def change
    create_table :student_profiles do |t|
      t.references :authentication_role, index: true, foreign_key: true, null: false
      t.string :parent_guardian_email, null: false
      t.date :date_of_birth

      t.timestamps null: false
    end
  end
end
