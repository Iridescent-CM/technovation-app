class CreateRegionalAmbassadorRegionalPitchEvents < ActiveRecord::Migration
  def change
    create_table :regional_pitch_events do |t|
      t.string :timezone, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.references :regional_ambassador_profile

      t.timestamps null: false
    end
  end
end
