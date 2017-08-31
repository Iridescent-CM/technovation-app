class RenameJoinableToTeamOnJoinRequests < ActiveRecord::Migration[5.1]
  def change
    remove_index :join_requests, [:joinable_type, :joinable_id]
    rename_column :join_requests, :joinable_id, :team_id
    add_index :join_requests, :team_id
    remove_column :join_requests, :joinable_type, :string
  end
end
