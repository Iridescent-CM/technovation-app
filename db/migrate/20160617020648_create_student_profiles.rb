class CreateStudentProfiles < ActiveRecord::Migration
  def change
    create_table :student_profiles do |t|
      t.integer :authentication_id, foreign_key: true, index: true, null: false
      t.string :parent_guardian_email, null: false
      t.date :date_of_birth, null: false

      t.timestamps null: false
    end
  end
end
