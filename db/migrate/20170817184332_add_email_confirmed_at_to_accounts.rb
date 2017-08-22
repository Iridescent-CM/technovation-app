class AddEmailConfirmedAtToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :email_confirmed_at, :datetime
  end
end
