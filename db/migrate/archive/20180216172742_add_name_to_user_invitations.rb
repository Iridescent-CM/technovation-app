class AddNameToUserInvitations < ActiveRecord::Migration[5.1]
  def change
    add_column :user_invitations, :name, :string
  end
end
