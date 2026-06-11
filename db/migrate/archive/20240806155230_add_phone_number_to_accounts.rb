class AddPhoneNumberToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :phone_number, :string
  end
end
