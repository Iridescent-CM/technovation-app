class AddSeasonsToRegionalPitchEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :regional_pitch_events, :seasons, :text, array: true, default: []
  end
end
