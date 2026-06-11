class DropGlobalInvitations < ActiveRecord::Migration[6.1]
  def change
    drop_table :global_invitations
  end
end
