class UpdateExistingAdminAccountStatus < ActiveRecord::Migration[5.1]
  def up
    Account.joins(:admin_profile).update_all(admin_status: :full_admin)
  end
end
