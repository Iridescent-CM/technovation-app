class AddMailerTokenToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :mailer_token, :string
    add_index :accounts, :mailer_token, unique: true
  end
end
