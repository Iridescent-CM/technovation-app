class CreateMentorProfiles < ActiveRecord::Migration
  def change
    create_table :mentor_profiles do |t|
      t.references :account, index: true, foreign_key: true, nulL: false
      t.string :school_company_name, null: false
      t.string :job_title, null: false
      t.date :background_check_completed_at

      t.timestamps null: false
    end
  end
end
