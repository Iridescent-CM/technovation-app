class RenameFriendlyIdOnTeams < ActiveRecord::Migration[4.2]
  def change
    rename_column :teams, :friendly_id, :legacy_id
  end
end
