class AddDivisionIdToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_reference :accounts, :division, foreign_key: true
  end
end
