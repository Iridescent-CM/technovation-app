class AddRegisterAtAnyTimeToUserInvitations < ActiveRecord::Migration[6.1]
  def change
    add_column :user_invitations, :register_at_any_time, :boolean
  end
end
