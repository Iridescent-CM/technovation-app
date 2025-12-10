class DropDivisionsRegionalPitchEvents < ActiveRecord::Migration[7.0]
  def up
    drop_table :divisions_regional_pitch_events
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
