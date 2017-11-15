class CreateUserInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_invitations do |t|
      t.string :admin_permission_token, null: false
      t.string :email, null: false
      t.integer :account_id
      t.integer :profile_type, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
