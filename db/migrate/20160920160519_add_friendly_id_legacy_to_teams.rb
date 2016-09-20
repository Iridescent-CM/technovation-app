class AddFriendlyIdLegacyToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :friendly_id, :string
    add_index :teams, :friendly_id
  end
end
