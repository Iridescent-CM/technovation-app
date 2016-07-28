class CreateMentorProfileExpertises < ActiveRecord::Migration
  def change
    create_table :mentor_profile_expertises do |t|
      t.references :mentor_profile, index: true, foreign_key: true, null: false
      t.references :expertise, index: true, foreign_key: true, nulL: false

      t.timestamps null: false
    end
  end
end
