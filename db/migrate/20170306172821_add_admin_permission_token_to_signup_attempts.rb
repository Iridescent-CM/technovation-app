class AddAdminPermissionTokenToSignupAttempts < ActiveRecord::Migration[4.2]
  def change
    add_column :signup_attempts, :admin_permission_token, :string
  end
end
