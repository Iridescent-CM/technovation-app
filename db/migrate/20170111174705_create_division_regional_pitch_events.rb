class CreateDivisionRegionalPitchEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :divisions_regional_pitch_events, id: false do |t|
      t.references :division, foreign_key: true
      t.references :regional_pitch_event, foreign_key: true
    end
  end
end
