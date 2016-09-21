class AddLastLoginIpToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :last_login_ip, :string
  end
end
