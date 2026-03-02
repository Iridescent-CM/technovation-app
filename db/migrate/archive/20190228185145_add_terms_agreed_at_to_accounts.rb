class AddTermsAgreedAtToAccounts < ActiveRecord::Migration[5.1]
  def up
    add_column :accounts, :terms_agreed_at, :datetime
  end

  def down
    remove_column :accounts, :terms_agreed_at
  end
end
