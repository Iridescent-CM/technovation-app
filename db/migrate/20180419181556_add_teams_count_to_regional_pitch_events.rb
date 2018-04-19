class AddTeamsCountToRegionalPitchEvents < ActiveRecord::Migration[5.1]
  def up
    add_column :regional_pitch_events, :teams_count, :integer, default: 0

    RegionalPitchEvent.includes(:teams).find_each do |event|
      event.update_column(:teams_count, event.teams.count)
    end
  end

  def down
    remove_column :regional_pitch_events, :teams_count
  end
end
