class CreateClubAmbassadorProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :club_ambassador_profiles do |t|
      t.belongs_to :account, foreign_key: true
      t.string :job_title
      t.datetime :training_completed_at

      t.timestamps
    end
  end
end
