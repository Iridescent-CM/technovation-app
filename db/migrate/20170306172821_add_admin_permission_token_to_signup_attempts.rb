class AddAdminPermissionTokenToSignupAttempts < ActiveRecord::Migration
  def change
    add_column :signup_attempts, :admin_permission_token, :string
  end
end
