class AddFriendlyIdLegacyToTeams < ActiveRecord::Migration[4.2]
  def change
    add_column :teams, :friendly_id, :string
    add_index :teams, :friendly_id
  end
end
