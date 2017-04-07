class CreateRegionalPitchEventsTeams < ActiveRecord::Migration[4.2]
  def change
    create_table :regional_pitch_events_teams, id: false do |t|
      t.references :regional_pitch_event, foreign_key: true
      t.references :team, foreign_key: true

      t.index [:regional_pitch_event_id, :team_id], unique: true, name: :pitch_events_teams
      t.index :team_id, name: :pitch_events_team_ids
    end
  end
end
