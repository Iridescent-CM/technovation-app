class AddUnofficialToRegionalPitchEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :regional_pitch_events, :unofficial, :boolean, default: false
  end
end
