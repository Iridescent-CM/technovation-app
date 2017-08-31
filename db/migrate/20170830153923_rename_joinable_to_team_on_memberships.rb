class RenameJoinableToTeamOnMemberships < ActiveRecord::Migration[5.1]
  def change
    remove_index :memberships, [:joinable_type, :joinable_id]
    rename_column :memberships, :joinable_id, :team_id
    add_index :memberships, :team_id
    remove_column :memberships, :joinable_type, :string
  end
end
