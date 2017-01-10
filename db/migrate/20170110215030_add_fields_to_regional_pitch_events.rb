class AddFieldsToRegionalPitchEvents < ActiveRecord::Migration
  def change
    add_reference :regional_pitch_events, :division, index: true, foreign_key: true
    add_column :regional_pitch_events, :city, :string
    add_column :regional_pitch_events, :venue_address, :string
    add_column :regional_pitch_events, :eventbrite_link, :string
  end
end
