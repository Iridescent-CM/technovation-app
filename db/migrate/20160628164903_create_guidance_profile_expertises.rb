class CreateGuidanceProfileExpertises < ActiveRecord::Migration
  def change
    create_table :guidance_profile_expertises do |t|
      t.references :guidance_profile, index: true, foreign_key: true, nulL: false
      t.references :expertise, index: true, foreign_key: true, nulL: false

      t.timestamps null: false
    end
  end
end
