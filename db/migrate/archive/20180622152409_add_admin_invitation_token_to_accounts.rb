class AddAdminInvitationTokenToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :admin_invitation_token, :string
    add_index :accounts, :admin_invitation_token, unique: true
  end
end
