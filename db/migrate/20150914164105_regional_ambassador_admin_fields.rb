class RegionalAmbassadorAdminFields < ActiveRecord::Migration
  def change
    add_column :admin_users, :role, :integer, :default => 0, :null => false
    add_column :admin_users, :country, :string
    add_column :admin_users, :state, :string
    add_column :teams, :state, :string
  end
end
