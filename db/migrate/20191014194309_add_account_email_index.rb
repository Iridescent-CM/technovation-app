class AddAccountEmailIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :accounts, :email, unique: true, where: "deleted_at IS NULL"
  end
end
