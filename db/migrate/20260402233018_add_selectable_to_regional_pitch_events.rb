class AddSelectableToRegionalPitchEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :regional_pitch_events, :selectable, :boolean, default: true, null: false
  end
end
