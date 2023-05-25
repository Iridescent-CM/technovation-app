class AddAdminTypeToAdminProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_profiles, :admin_type, :integer, default: 0, null: false
  end
end
