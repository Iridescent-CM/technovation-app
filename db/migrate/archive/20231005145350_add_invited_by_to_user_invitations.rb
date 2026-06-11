class AddInvitedByToUserInvitations < ActiveRecord::Migration[6.1]
  def change
    add_column :user_invitations, :invited_by_id, :integer
  end
end
