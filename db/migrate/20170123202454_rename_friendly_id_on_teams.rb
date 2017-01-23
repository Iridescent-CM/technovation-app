class RenameFriendlyIdOnTeams < ActiveRecord::Migration
  def change
    rename_column :teams, :friendly_id, :legacy_id
  end
end
