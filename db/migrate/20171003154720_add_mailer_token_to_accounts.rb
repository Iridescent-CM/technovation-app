class AddMailerTokenToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :mailer_token, :string
  end
end
