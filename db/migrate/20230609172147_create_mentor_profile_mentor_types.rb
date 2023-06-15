class CreateMentorProfileMentorTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :mentor_profile_mentor_types do |t|
      t.references :mentor_profile, foreign_key: true
      t.references :mentor_type, foreign_key: true

      t.timestamps
    end
  end
end
