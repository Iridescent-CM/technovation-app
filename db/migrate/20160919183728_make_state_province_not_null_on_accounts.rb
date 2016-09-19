class MakeStateProvinceNotNullOnAccounts < ActiveRecord::Migration
  def change
    change_column_null :accounts, :state_province, true
  end
end
