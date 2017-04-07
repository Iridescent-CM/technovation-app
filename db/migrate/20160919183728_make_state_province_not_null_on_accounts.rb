class MakeStateProvinceNotNullOnAccounts < ActiveRecord::Migration[4.2]
  def change
    change_column_null :accounts, :state_province, true
  end
end
