class AddBackgroundCheckExemptionToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :background_check_exemption, :boolean, default: false, null: false
  end
end
