class AddNameToRegionalPitchEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :regional_pitch_events, :name, :string
  end
end
