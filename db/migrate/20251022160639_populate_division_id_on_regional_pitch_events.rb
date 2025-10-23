class PopulateDivisionIdOnRegionalPitchEvents < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL.squish
      update regional_pitch_events
      set division_id = (
          select division_id
          from divisions_regional_pitch_events
          where divisions_regional_pitch_events.regional_pitch_event_id = regional_pitch_events.id
          limit 1
      )
    SQL
  end

  def down
    execute "UPDATE regional_pitch_events SET division_id = NULL"
  end
end
