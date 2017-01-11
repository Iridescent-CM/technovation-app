class AddNameToRegionalPitchEvents < ActiveRecord::Migration
  def change
    add_column :regional_pitch_events, :name, :string
  end
end
