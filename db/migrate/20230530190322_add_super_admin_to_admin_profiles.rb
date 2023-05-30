class AddSuperAdminToAdminProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_profiles, :super_admin, :boolean, null: false, default: false
  end
end
