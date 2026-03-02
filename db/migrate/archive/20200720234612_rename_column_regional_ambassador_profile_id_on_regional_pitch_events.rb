class RenameColumnRegionalAmbassadorProfileIdOnRegionalPitchEvents < ActiveRecord::Migration[5.1]
  def change
    rename_column :regional_pitch_events, :regional_ambassador_profile_id, :chapter_ambassador_profile_id
  end
end
