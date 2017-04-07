class AddLocaleToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :locale, :string, null: false, default: :en
  end
end
