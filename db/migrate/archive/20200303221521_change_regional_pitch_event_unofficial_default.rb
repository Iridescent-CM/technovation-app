class ChangeRegionalPitchEventUnofficialDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default :regional_pitch_events, :unofficial, true
  end
end
