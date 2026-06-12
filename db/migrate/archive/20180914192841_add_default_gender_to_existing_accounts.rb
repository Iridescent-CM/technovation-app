class AddDefaultGenderToExistingAccounts < ActiveRecord::Migration[5.1]
  def up
    Account.where(gender: nil).update_all(gender: "Prefer not to say")
  end

  def down
  end
end
