class AddCapacityColumnToRegionalPitchEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :regional_pitch_events, :capacity, :integer
  end
end
