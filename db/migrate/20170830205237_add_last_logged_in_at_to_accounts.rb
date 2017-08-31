class AddLastLoggedInAtToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :last_logged_in_at, :datetime
  end
end
