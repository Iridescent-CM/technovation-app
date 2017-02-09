class AddUnofficialToRegionalPitchEvents < ActiveRecord::Migration
  def change
    add_column :regional_pitch_events, :unofficial, :boolean, default: false
  end
end
