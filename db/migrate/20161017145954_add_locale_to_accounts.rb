class AddLocaleToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :locale, :string, null: false, default: "en-US"
  end
end
